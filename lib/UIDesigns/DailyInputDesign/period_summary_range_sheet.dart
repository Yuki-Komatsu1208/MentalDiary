import 'package:flutter/material.dart';

import '../../Entities/period_summary.dart';

///期間サマリの範囲指定シートUI
class PeriodSummaryRangeSheet extends StatefulWidget {
  const PeriodSummaryRangeSheet({
    super.key,
    required this.initialRange,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTimeRange initialRange;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<PeriodSummaryRangeSheet> createState() =>
      _PeriodSummaryRangeSheetState();
}

//期間サマリの範囲指定シートの状態を管理するクラス
class _PeriodSummaryRangeSheetState extends State<PeriodSummaryRangeSheet> {
  late DateTimeRange _selectedRange;

  @override
  void initState() {
    super.initState();
    _selectedRange = DateTimeRange(
      start: DateUtils.dateOnly(widget.initialRange.start),
      end: DateUtils.dateOnly(widget.initialRange.end),
    );
  }

  ///表示用の日付ラベルを返す
  String _buildDateLabel(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日';
  }

  ///開始日と終了日をまとめて選択する
  Future<void> _selectDateRange() async {
    final DateTimeRange? selectedRange = await showDateRangePicker(
      context: context,
      initialDateRange: _selectedRange,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      helpText: '集計する期間を選択',
      cancelText: '閉じる',
      confirmText: '決定',
      saveText: '決定',
      builder: (BuildContext context, Widget? child) {
        final ThemeData theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: const Color(0xFF171411),
              onPrimary: const Color(0xFFF8F3EA),
              surface: const Color(0xFFF8F3EA),
              onSurface: const Color(0xFF171411),
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFFF8F3EA),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (selectedRange == null || !mounted) {
      return;
    }

    setState(() {
      _selectedRange = DateTimeRange(
        start: DateUtils.dateOnly(selectedRange.start),
        end: DateUtils.dateOnly(selectedRange.end),
      );
    });
  }

  ///期間選択カードUIを返す
  Widget _buildRangeCard() {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFF2F2924), width: 1.1),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '選択中の期間',
                  style: textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF6A5F54),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_buildDateLabel(_selectedRange.start)} 〜\n${_buildDateLabel(_selectedRange.end)}',
                  style: textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF171411),
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: _selectDateRange,
            icon: const Icon(Icons.date_range),
            label: const Text('選択'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF171411),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('期間サマリ', style: textTheme.headlineMedium),
            const SizedBox(height: 10),
            Text(
              '一つのカレンダーで開始日と終了日を選んでください。',
              style: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF5C544C),
              ),
            ),
            const SizedBox(height: 20),
            _buildRangeCard(),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              decoration: BoxDecoration(
                color: const Color(0xFF201A15),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                PeriodSummary.formatDateRange(
                  _selectedRange.start,
                  _selectedRange.end,
                ),
                style: textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFFFAF3E7),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop(_selectedRange);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF171411),
                  foregroundColor: const Color(0xFFF8F3EA),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('この期間で集計する'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
