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
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = DateUtils.dateOnly(widget.initialRange.start);
    _endDate = DateUtils.dateOnly(widget.initialRange.end);
  }

  ///表示用の日付ラベルを返す
  String _buildDateLabel(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日';
  }

  ///開始日または終了日を選択する
  Future<void> _selectDate({required bool isStartDate}) async {
    final DateTime initialDate = isStartDate ? _startDate : _endDate;
    final DateTime firstDate = isStartDate ? widget.firstDate : _startDate;
    final DateTime lastDate = isStartDate ? _endDate : widget.lastDate;

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: isStartDate ? '開始日を選択' : '終了日を選択',
      cancelText: '閉じる',
      confirmText: '決定',
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

    if (selectedDate == null || !mounted) {
      return;
    }

    setState(() {
      if (isStartDate) {
        _startDate = DateUtils.dateOnly(selectedDate);
      } else {
        _endDate = DateUtils.dateOnly(selectedDate);
      }
    });
  }

  ///日付選択カードUIを返す
  Widget _buildDateCard({
    required String title,
    required DateTime date,
    required VoidCallback onPressed,
  }) {
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
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF6A5F54),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _buildDateLabel(date),
                  style: textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF171411),
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.event),
            label: const Text('変更'),
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
              '集計したい開始日と終了日を選んでください。',
              style: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF5C544C),
              ),
            ),
            const SizedBox(height: 20),
            _buildDateCard(
              title: '開始日',
              date: _startDate,
              onPressed: () {
                _selectDate(isStartDate: true);
              },
            ),
            const SizedBox(height: 12),
            _buildDateCard(
              title: '終了日',
              date: _endDate,
              onPressed: () {
                _selectDate(isStartDate: false);
              },
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              decoration: BoxDecoration(
                color: const Color(0xFF201A15),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                PeriodSummary.formatDateRange(_startDate, _endDate),
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
                  Navigator.of(context).pop(
                    DateTimeRange(start: _startDate, end: _endDate),
                  );
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
