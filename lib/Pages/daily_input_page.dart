import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './/Entities/daily_status.dart';
import '../Helpers/load_helper.dart';
import '../Helpers/save_helper.dart';
import '../UIDesigns/DailyInputDesign/daily_input_hero_section.dart';
import '../UIDesigns/DailyInputDesign/daily_input_section_card.dart';
import '../UIDesigns/DailyInputDesign/daily_status_calendar_sheet.dart';
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

  //気分を更新して保存する
  Future<void> _updateMood(int value) async {
    setState(() {
      dailyStatus.Mood = value;
    });
    await _saveCurrentStatus();
  }

  //興味・関心を更新して保存する
  Future<void> _updateInterest(int value) async {
    setState(() {
      dailyStatus.Interest = value;
    });
    await _saveCurrentStatus();
  }

  //活力を更新して保存する
  Future<void> _updateEnergy(int value) async {
    setState(() {
      dailyStatus.Energy = value;
    });
    await _saveCurrentStatus();
  }

  //睡眠の質を更新して保存する
  Future<void> _updateSleepQuality(int value) async {
    setState(() {
      dailyStatus.SleepQuality = value;
    });
    await _saveCurrentStatus();
  }

  //ストレス・不安を更新して保存する
  Future<void> _updateStressed(int value) async {
    setState(() {
      dailyStatus.Stressed = value;
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

  //表示用の日付文字列を返す
  String _buildDateLabel() {
    final DateTime date = dailyStatus.Date;
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  //状態値の平均から短いサマリーを返す
  String _buildSummaryLabel() {
    final int convertedStressScore = 6 - dailyStatus.Stressed;
    final int averageScore =
        ((dailyStatus.Mood +
                    dailyStatus.Interest +
                    dailyStatus.Energy +
                    dailyStatus.SleepQuality +
                    convertedStressScore) /
                5)
            .round();

    switch (averageScore) {
      case 5:
        return '高い集中と安定感があります';
      case 4:
        return '落ち着いたバランスです';
      case 3:
        return 'フラットな一日です';
      case 2:
        return '少し休息を優先したい状態です';
      default:
        return 'ゆっくり整える日です';
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
        children: <Widget>[
          DailyInputHeroSection(
            dateLabel: _buildDateLabel(),
            summaryLabel: _buildSummaryLabel(),
            moodValue: dailyStatus.Mood,
            energyValue: dailyStatus.Energy,
            sleepValue: dailyStatus.SleepQuality,
            onCalendarPressed: () {
              _showCalendarModal();
            },
          ),
          const SizedBox(height: 18),
          DailyInputSectionCard(
            eyebrow: 'CONDITION',
            title: 'コンディションを1~5で入力しましょう',
            child: Column(
              children: <Widget>[
                StatusSlider(
                  label: '気分',
                  value: dailyStatus.Mood,
                  onChanged: _updateMood,
                  valueLabels: const <String>[
                    'かなり落ち込む',
                    '少し沈む',
                    'ふつう',
                    '安定している',
                    'とても良い',
                  ],
                  minHint: 'かなり落ち込む',
                  maxHint: 'とても良い',
                ),
                StatusSlider(
                  label: '興味・関心',
                  value: dailyStatus.Interest,
                  onChanged: _updateInterest,
                  valueLabels: const <String>[
                    'ほとんど湧かない',
                    '少し湧く',
                    'ふつう',
                    'しっかり湧く',
                    '強く湧く',
                  ],
                  minHint: 'ほとんど湧かない',
                  maxHint: '強く湧く',
                ),
                StatusSlider(
                  label: '活力',
                  value: dailyStatus.Energy,
                  onChanged: _updateEnergy,
                  valueLabels: const <String>[
                    'ほとんど動けない',
                    'かなり低い',
                    'ふつう',
                    '十分にある',
                    'とても満ちている',
                  ],
                  minHint: 'ほとんど動けない',
                  maxHint: 'とても満ちている',
                ),
                StatusSlider(
                  label: '睡眠の質',
                  value: dailyStatus.SleepQuality,
                  onChanged: _updateSleepQuality,
                  valueLabels: const <String>[
                    '全く眠れない',
                    'あまり眠れない',
                    'ふつう',
                    '概ね眠れている',
                    '安眠できている',
                  ],
                  minHint: '全く眠れない',
                  maxHint: '安眠できている',
                ),
                StatusSlider(
                  label: 'ストレス・不安を感じる',
                  value: dailyStatus.Stressed,
                  onChanged: _updateStressed,
                  valueLabels: const <String>[
                    'まったく不安を感じない',
                    '少し感じる',
                    'やや感じる',
                    'かなり感じる',
                    '強く不安を感じる',
                  ],
                  minHint: 'まったく不安を感じない',
                  maxHint: '強く不安を感じる',
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          DailyInputSectionCard(
            eyebrow: 'NOTE',
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
    );
  }
}
