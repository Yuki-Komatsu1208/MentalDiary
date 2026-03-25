import 'package:flutter/material.dart';

//日次入力画面の上部ヒーローUI
class DailyInputHeroSection extends StatelessWidget {
  const DailyInputHeroSection({
    super.key,
    required this.dateLabel,
    required this.summaryLabel,
    required this.moodValue,
    required this.energyValue,
    required this.sleepValue,
    required this.onCalendarPressed,
  });

  final String dateLabel;
  final String summaryLabel;
  final int moodValue;
  final int energyValue;
  final int sleepValue;
  final VoidCallback onCalendarPressed;

  //上部のサマリー値UIを返す
  Widget _buildHeroMetric(String label, int value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1D1D1D),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFF343434), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF9D9D9D),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '$value / 5',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //ヒーローカード内のカレンダーボタンUIを返す
  Widget _buildCalendarButton() {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: const Color(0xFF1D1D1D),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xFF343434), width: 1),
        ),
      ),
      icon: const Icon(Icons.calendar_month),
      onPressed: onCalendarPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(32),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 30,
            offset: Offset(0, 14),
          ),
        ],
      ),
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
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: const Color(0xFF4A4A4A),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    dateLabel,
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _buildCalendarButton(),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '今日の状態を\n記録してください',
            style: textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            summaryLabel,
            style: textTheme.bodyLarge?.copyWith(
              color: const Color(0xFFD7D3CA),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: <Widget>[
              _buildHeroMetric('MOOD', moodValue),
              const SizedBox(width: 12),
              _buildHeroMetric('ENERGY', energyValue),
              const SizedBox(width: 12),
              _buildHeroMetric('SLEEP', sleepValue),
            ],
          ),
        ],
      ),
    );
  }
}
