import 'package:mental_diary/Entities/daily_status.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'daily_status_calendar_day_cell.dart';
import 'daily_status_calendar_legend_item.dart';

//日次入力画面のカレンダーボトムシートUI
class DailyStatusCalendarSheet extends StatefulWidget {
  const DailyStatusCalendarSheet({
    super.key,
    required this.statusMap,
    required this.initialFocusedDay,
    required this.onDateSelected,
  });

  final Map<DateTime, DailyStatus> statusMap;
  final DateTime initialFocusedDay;
  final ValueChanged<DateTime> onDateSelected;

  @override
  State<DailyStatusCalendarSheet> createState() => _DailyStatusCalendarSheet();
}

//カレンダーボトムシートの状態を管理するクラス
class _DailyStatusCalendarSheet extends State<DailyStatusCalendarSheet> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateUtils.dateOnly(widget.initialFocusedDay);
    _selectedDay = DateUtils.dateOnly(widget.initialFocusedDay);
  }

  //指定日付の状態を返す
  DailyStatus? _getStatus(DateTime day) {
    return widget.statusMap[DateUtils.dateOnly(day)];
  }

  //カレンダー本体を包むカードUIを返す
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: _buildCalendarCard(
                TableCalendar<DailyStatus>(
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2100),
                  focusedDay: _focusedDay,
                  rowHeight: 128,
                  selectedDayPredicate: (DateTime day) {
                    return isSameDay(_selectedDay, day);
                  },
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
                    selectedDecoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
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
                  calendarBuilders: CalendarBuilders<DailyStatus>(
                    defaultBuilder: (BuildContext context, DateTime day, _) {
                      return DailyStatusCalendarDayCell(
                        day: day,
                        status: _getStatus(day),
                        isToday: false,
                        isSelected: false,
                        isOutside: false,
                      );
                    },
                    todayBuilder: (BuildContext context, DateTime day, _) {
                      return DailyStatusCalendarDayCell(
                        day: day,
                        status: _getStatus(day),
                        isToday: true,
                        isSelected: false,
                        isOutside: false,
                      );
                    },
                    selectedBuilder: (BuildContext context, DateTime day, _) {
                      return DailyStatusCalendarDayCell(
                        day: day,
                        status: _getStatus(day),
                        isToday: isSameDay(day, DateTime.now()),
                        isSelected: true,
                        isOutside: false,
                      );
                    },
                    outsideBuilder: (BuildContext context, DateTime day, _) {
                      return DailyStatusCalendarDayCell(
                        day: day,
                        status: _getStatus(day),
                        isToday: false,
                        isSelected: false,
                        isOutside: true,
                      );
                    },
                  ),
                  onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                    setState(() {
                      _selectedDay = DateUtils.dateOnly(selectedDay);
                      _focusedDay = DateUtils.dateOnly(focusedDay);
                    });
                    widget.onDateSelected(_selectedDay);
                  },
                  onPageChanged: (DateTime focusedDay) {
                    setState(() {
                      _focusedDay = DateUtils.dateOnly(focusedDay);
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: <Widget>[
                const DailyStatusCalendarLegendItem(
                  label: '気分',
                  color: Color.fromARGB(255, 216, 175, 73),
                ),
                const DailyStatusCalendarLegendItem(
                  label: '興味',
                  color: Color(0xFF6F9272),
                ),
                const DailyStatusCalendarLegendItem(
                  label: '活力',
                  color: Color(0xFFC7812F),
                ),
                const DailyStatusCalendarLegendItem(
                  label: '睡眠',
                  color: Color(0xFF5F78A6),
                ),
                const DailyStatusCalendarLegendItem(
                  label: '不安',
                  color: Color(0xFFA13F3F),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
