import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './/Entities/daily_status.dart';
import './/Entities/period_summary.dart';
import './/Entities/VO/daily_status_score.dart';
import '../Helpers/load_helper.dart';
import '../Helpers/save_helper.dart';
import '../UIDesigns/DailyInputDesign/daily_input_hero_section.dart';
import '../UIDesigns/DailyInputDesign/hide_on_scroll_header_layout.dart';
import '../UIDesigns/DailyInputDesign/daily_input_section_card.dart';
import '../UIDesigns/DailyInputDesign/daily_status_calendar_sheet.dart';
import '../UIDesigns/DailyInputDesign/period_summary_range_sheet.dart';
import '../UIDesigns/DailyInputDesign/period_summary_sheet.dart';
import '../UIDesigns/SliderDesign/status_slider.dart';

//日々の入力ページ
//状態を持つウィジェットの定義。
class DailyInputPage extends StatefulWidget {
  const DailyInputPage({super.key});

  @override
  State<DailyInputPage> createState() => _DailyInputPage();
}

//上記で定義したウェジットの状態とUIを定義するクラス
class _DailyInputPage extends State<DailyInputPage> {
  DailyStatus dailyStatus = DailyStatus(Date: DateTime.now());
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStatusForDate(dailyStatus.Date);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  //指定日の状態を読み込んで画面に反映する
  Future<void> _loadStatusForDate(DateTime date) async {
    final DailyStatus loadedStatus = await LoadHelper.loadStatusByDate(date);
    if (!mounted) {
      return;
    }

    setState(() {
      dailyStatus = loadedStatus;
      _noteController.text = dailyStatus.Note;
    });
  }

  //現在の入力状態を自動保存する
  Future<void> _saveCurrentStatus() async {
    await SaveHelper.saveSingleStatus(dailyStatus);
  }

  //日付を変更して保存済み状態を読み込む
  Future<void> _changeDate(DateTime date) async {
    await _loadStatusForDate(date);
  }

  //状態値を更新して保存する
  Future<void> _updateStatusValue(
    DailyStatusParameter parameter,
    int value,
  ) async {
    setState(() {
      dailyStatus.updateScore(parameter, value);
    });
    await _saveCurrentStatus();
  }

  //メモを更新して保存する
  Future<void> _updateNote(String value) async {
    setState(() {
      dailyStatus.Note = value;
    });
    await _saveCurrentStatus();
  }

  Widget _buildStatusSlider(DailyStatusParameter parameter) {
    final DailyStatusParameterDefinition definition = parameter.definition;
    final DailyStatusScore score = dailyStatus.scoreOf(parameter);

    return StatusSlider(
      label: definition.label,
      value: score.value,
      onChanged: (int value) {
        _updateStatusValue(parameter, value);
      },
      currentValueLabel: score.getDisplayValue(),
      minHint: definition.minHint,
      maxHint: definition.maxHint,
    );
  }

  //表示用の日付文字列を返す
  String _buildDateLabel() {
    final DateTime date = dailyStatus.Date;
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  //カレンダーモーダルを表示する
  Future<void> _showCalendarModal() async {
    final Map<DateTime, DailyStatus> statusMap =
        await LoadHelper.loadDailyStatusMap();
    if (!mounted) {
      return;
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.96,
          child: DailyStatusCalendarSheet(
            statusMap: statusMap,
            initialFocusedDay: dailyStatus.Date,
            onDateSelected: (DateTime date) {
              Navigator.of(context).pop();
              _changeDate(date);
            },
          ),
        );
      },
    );
  }

  //期間サマリの範囲指定シートを表示する
  Future<DateTimeRange?> _showPeriodRangeModal() async {
    final DateTimeRange initialRange = DateTimeRange(
      start: DateUtils.dateOnly(dailyStatus.Date.subtract(const Duration(days: 6))),
      end: DateUtils.dateOnly(dailyStatus.Date),
    );

    return showModalBottomSheet<DateTimeRange>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: PeriodSummaryRangeSheet(
            initialRange: initialRange,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          ),
        );
      },
    );
  }

  //期間サマリ結果のシートを表示する
  Future<void> _showPeriodSummaryModal(PeriodSummary summary) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.92,
          child: PeriodSummarySheet(summary: summary),
        );
      },
    );
  }

  //期間指定から期間サマリ表示までを行う
  Future<void> _showPeriodSummaryFlow() async {
    final DateTimeRange? selectedRange = await _showPeriodRangeModal();
    if (selectedRange == null) {
      return;
    }

    final Map<DateTime, DailyStatus> statusMap =
        await LoadHelper.loadDailyStatusMap();
    if (!mounted) {
      return;
    }

    final PeriodSummary summary = PeriodSummary.fromStatusMap(
      statusMap: statusMap,
      startDate: selectedRange.start,
      endDate: selectedRange.end,
    );

    await _showPeriodSummaryModal(summary);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: HideOnScrollHeaderLayout(
          header: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            decoration: const BoxDecoration(
              color: Color(0xFF12100E),
              border: Border(
                bottom: BorderSide(color: Color(0xFF4A4036), width: 1),
              ),
            ),
            child: DailyInputHeroSection(
              dateLabel: _buildDateLabel(),
              summaryLabel: dailyStatus.summaryLabel,
              onCalendarPressed: () {
                _showCalendarModal();
              },
              onPeriodSummaryPressed: () {
                _showPeriodSummaryFlow();
              },
            ),
          ),
          body: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
            children: <Widget>[
              DailyInputSectionCard(
                title: '今日の状態を記録しましょう',
                child: Column(
                  children: dailyStatusParameterDisplayOrder
                      .map(_buildStatusSlider)
                      .toList(),
                ),
              ),
              const SizedBox(height: 18),
              DailyInputSectionCard(
                title: '今日の一言を残す',
                child: TextFormField(
                  controller: _noteController,
                  maxLength: 300,
                  maxLengthEnforcement: MaxLengthEnforcement.none,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  minLines: 5,
                  maxLines: 8,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    labelText: '静かなメモ、気になったこと、残したい感覚',
                  ),
                  validator: (String? value) {
                    if (value != null && value.length > 300) {
                      return '300文字以内で入力してください';
                    }
                    return null;
                  },
                  //入力の値変更のたびに保存
                  onChanged: _updateNote,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
