import 'package:mental_diary/Entities/daily_status.dart';
import 'package:flutter/material.dart';

import 'daily_status_donut.dart';

//カレンダーの日付セルUI
class DailyStatusCalendarDayCell extends StatelessWidget {
  const DailyStatusCalendarDayCell({
    super.key,
    required this.day,
    required this.status,
    required this.isToday,
    required this.isSelected,
    required this.isOutside,
  });

  final DateTime day;
  final DailyStatus? status;
  final bool isToday;
  final bool isSelected;
  final bool isOutside;

  @override
  Widget build(BuildContext context) {
    final Color textColor = isOutside
        ? const Color(0xFFB4B4B4)
        : isSelected
        ? Colors.white
        : const Color(0xFF111111);

    final Color backgroundColor = isSelected
        ? const Color(0xFF111111)
        : isToday
        ? const Color(0xFFF1ECE2)
        : Colors.transparent;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      padding: const EdgeInsets.fromLTRB(4, 6, 4, 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF111111)
              : isToday
              ? const Color(0xFF111111)
              : Colors.transparent,
          width: isToday ? 1 : 0,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            '${day.day}',
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          if (status != null)
            Opacity(
              opacity: isOutside ? 0.35 : 1,
              child: DailyStatusDonut(status: status!, size: 30),
            )
          else
            const SizedBox(height: 30),
        ],
      ),
    );
  }
}
