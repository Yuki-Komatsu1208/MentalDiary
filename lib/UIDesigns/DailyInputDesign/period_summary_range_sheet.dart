import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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
  late DateTime _focusedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  bool _isCalendarVisible = false;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateUtils.dateOnly(widget.initialRange.start);
    _rangeStart = DateUtils.dateOnly(widget.initialRange.start);
    _rangeEnd = DateUtils.dateOnly(widget.initialRange.end);
  }

  ///表示用の日付ラベルを返す
  String _buildDateLabel(DateTime? date) {
    if (date == null) {
      return '未選択';
    }

    return '${date.year}年${date.month}月${date.day}日';
  }

  ///日付が選択範囲に含まれるかを返す
  bool _isWithinRange(DateTime day) {
    if (_rangeStart == null || _rangeEnd == null) {
      return false;
    }

    final DateTime normalizedDay = DateUtils.dateOnly(day);
    return !normalizedDay.isBefore(_rangeStart!) &&
        !normalizedDay.isAfter(_rangeEnd!);
  }

  ///期間ラベルを返す
  String _buildRangeLabel() {
    if (_rangeStart == null || _rangeEnd == null) {
      return '開始日と終了日を選択してください';
    }

    return PeriodSummary.formatDateRange(_rangeStart!, _rangeEnd!);
  }

  ///日付セルUIを返す
  Widget _buildDayCell(
    BuildContext context,
    DateTime day, {
    required bool isOutside,
    required bool isToday,
  }) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isRangeStart = _rangeStart != null && isSameDay(day, _rangeStart);
    final bool isRangeEnd = _rangeEnd != null && isSameDay(day, _rangeEnd);
    final bool isInRange = _isWithinRange(day);

    Color textColor = const Color(0xFF171411);
    if (isOutside) {
      textColor = const Color(0xFFAEA59A);
    }

    if (isRangeStart || isRangeEnd) {
      textColor = const Color(0xFFF8F3EA);
    }

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isRangeStart || isRangeEnd
              ? const Color(0xFF171411)
              : isInRange
              ? const Color(0x26D8C5A8)
              : Colors.transparent,
          border: isToday && !isRangeStart && !isRangeEnd
              ? Border.all(color: const Color(0xFF171411), width: 1)
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          '${day.day}',
          style: textTheme.titleMedium?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  ///日付範囲選択時の処理を行う
  void _handleRangeSelected(
    DateTime? start,
    DateTime? end,
    DateTime focusedDay,
  ) {
    setState(() {
      _focusedDay = DateUtils.dateOnly(focusedDay);
      _rangeStart = start == null ? null : DateUtils.dateOnly(start);
      _rangeEnd = end == null ? null : DateUtils.dateOnly(end);
    });
  }

  ///カレンダー本体を包むカードUIを返す
  Widget _buildCalendarCard(Widget child) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF111111), width: 1.2),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  ///期間表示カードUIを返す
  Widget _buildRangeTriggerCard(TextTheme textTheme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          setState(() {
            _isCalendarVisible = !_isCalendarVisible;
          });
        },
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          decoration: BoxDecoration(
            color: const Color(0xFF201A15),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '${_buildDateLabel(_rangeStart)} 〜 ${_buildDateLabel(_rangeEnd)}',
                  style: textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFFFAF3E7),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                _isCalendarVisible
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: const Color(0xFFFAF3E7),
              ),
            ],
          ),
        ),
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
              '期間表示を押して開始日と終了日を選んでください',
              style: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF5C544C),
              ),
            ),
            const SizedBox(height: 16),
            _buildRangeTriggerCard(textTheme),
            if (_isCalendarVisible) ...<Widget>[
              const SizedBox(height: 14),
              _buildCalendarCard(
                TableCalendar<void>(
                  firstDay: DateUtils.dateOnly(widget.firstDate),
                  lastDay: DateUtils.dateOnly(widget.lastDate),
                  focusedDay: _focusedDay,
                  rowHeight: 54,
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  rangeSelectionMode: RangeSelectionMode.toggledOn,
                  headerStyle: const HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    headerPadding: EdgeInsets.fromLTRB(2, 6, 2, 14),
                    leftChevronPadding: EdgeInsets.all(6),
                    rightChevronPadding: EdgeInsets.all(6),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: Color(0xFF111111),
                      size: 22,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: Color(0xFF111111),
                      size: 22,
                    ),
                    titleTextStyle: TextStyle(
                      color: Color(0xFF111111),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  ),
                  calendarStyle: const CalendarStyle(
                    outsideDaysVisible: true,
                    cellMargin: EdgeInsets.zero,
                    cellPadding: EdgeInsets.zero,
                    markersMaxCount: 0,
                    defaultDecoration: BoxDecoration(color: Colors.transparent),
                    todayDecoration: BoxDecoration(color: Colors.transparent),
                    selectedDecoration: BoxDecoration(color: Colors.transparent),
                    rangeStartDecoration: BoxDecoration(color: Colors.transparent),
                    rangeEndDecoration: BoxDecoration(color: Colors.transparent),
                    withinRangeDecoration: BoxDecoration(color: Colors.transparent),
                    rangeHighlightColor: Colors.transparent,
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    decoration: BoxDecoration(color: Colors.transparent),
                    weekdayStyle: TextStyle(
                      color: Color(0xFF7A7A7A),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                    weekendStyle: TextStyle(
                      color: Color(0xFF7A7A7A),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders<void>(
                    defaultBuilder: (BuildContext context, DateTime day, _) {
                      return _buildDayCell(
                        context,
                        day,
                        isOutside: false,
                        isToday: false,
                      );
                    },
                    todayBuilder: (BuildContext context, DateTime day, _) {
                      return _buildDayCell(
                        context,
                        day,
                        isOutside: false,
                        isToday: true,
                      );
                    },
                    outsideBuilder: (BuildContext context, DateTime day, _) {
                      return _buildDayCell(
                        context,
                        day,
                        isOutside: true,
                        isToday: false,
                      );
                    },
                    rangeStartBuilder: (BuildContext context, DateTime day, _) {
                      return _buildDayCell(
                        context,
                        day,
                        isOutside: false,
                        isToday: isSameDay(day, DateTime.now()),
                      );
                    },
                    rangeEndBuilder: (BuildContext context, DateTime day, _) {
                      return _buildDayCell(
                        context,
                        day,
                        isOutside: false,
                        isToday: isSameDay(day, DateTime.now()),
                      );
                    },
                    withinRangeBuilder: (BuildContext context, DateTime day, _) {
                      return _buildDayCell(
                        context,
                        day,
                        isOutside: false,
                        isToday: isSameDay(day, DateTime.now()),
                      );
                    },
                  ),
                  onRangeSelected: _handleRangeSelected,
                  onPageChanged: (DateTime focusedDay) {
                    setState(() {
                      _focusedDay = DateUtils.dateOnly(focusedDay);
                    });
                  },
                ),
              ),
            ],
            const SizedBox(height: 14),
            Text(
              _buildRangeLabel(),
              style: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF5C544C),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _rangeStart != null && _rangeEnd != null
                    ? () {
                        Navigator.of(context).pop(
                          DateTimeRange(start: _rangeStart!, end: _rangeEnd!),
                        );
                      }
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF171411),
                  foregroundColor: const Color(0xFFF8F3EA),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('集計'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
