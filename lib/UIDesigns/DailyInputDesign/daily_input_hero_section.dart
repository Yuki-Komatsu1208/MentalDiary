import 'package:flutter/material.dart';

//日次入力画面の上部ヒーローUI
class DailyInputHeroSection extends StatelessWidget {
  const DailyInputHeroSection({
    super.key,
    required this.dateLabel,
    required this.summaryLabel,
    required this.onCalendarPressed,
    required this.onPeriodSummaryPressed,
  });

  final String dateLabel;
  final String summaryLabel;
  final VoidCallback onCalendarPressed;
  final VoidCallback onPeriodSummaryPressed;

  //ヒーローカード内のアクションボタンUIを返す
  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    String? label,
  }) {
    final ButtonStyle style = IconButton.styleFrom(
      backgroundColor: const Color(0xFFF6EDDE),
      foregroundColor: const Color(0xFF14110E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFA28F79), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );

    if (label == null) {
      return IconButton(
        style: style,
        icon: Icon(icon),
        onPressed: onPressed,
      );
    }

    return TextButton.icon(
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFFF6EDDE),
        foregroundColor: const Color(0xFF14110E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xFFA28F79), width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF201A15),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: const Color(0xFF6D6256),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    dateLabel,
                    style: textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFFAF3E7),
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                icon: Icons.insights_outlined,
                label: '期間サマリ',
                onPressed: onPeriodSummaryPressed,
              ),
              const SizedBox(width: 10),
              _buildActionButton(
                icon: Icons.calendar_month,
                onPressed: onCalendarPressed,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              color: const Color(0xFF201A15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF6D6256),
                width: 1,
              ),
            ),
            child: Text(
              summaryLabel,
              style: textTheme.bodyLarge?.copyWith(
                color: const Color(0xFFFAF3E7),
                fontSize: 15,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
