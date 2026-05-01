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

  //ヒーローカードの背景装飾を返す
  Widget _buildBackgroundAccent({
    required double top,
    required double left,
    required double width,
    required double height,
    required List<Color> colors,
  }) {
    return Positioned(
      top: top,
      left: left,
      child: IgnorePointer(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: colors),
          ),
        ),
      ),
    );
  }

  //ヒーローカード内のアクションボタンUIを返す
  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    String? label,
  }) {
    if (label == null) {
      return IconButton(
        style: IconButton.styleFrom(
          backgroundColor: const Color(0x1FF8EFE1),
          foregroundColor: const Color(0xFFF7EFE3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF6E6256), width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          minimumSize: const Size(46, 46),
        ),
        icon: Icon(icon),
        onPressed: onPressed,
      );
    }

    return TextButton.icon(
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFFF7EEDD),
        foregroundColor: const Color(0xFF16120F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xFFD3BEA3), width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        minimumSize: const Size(0, 46),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }

  //ヘッダ上段のラベル群を返す
  Widget _buildTopLabels(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x14FFF8ED),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFF6D6258), width: 1),
      ),
      child: Text(
        dateLabel,
        style: textTheme.titleMedium?.copyWith(
          color: const Color(0xFFF8F0E5),
          letterSpacing: 0.9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF4B4035), width: 1),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF211A15),
            Color(0xFF17120F),
          ],
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          _buildBackgroundAccent(
            top: -36,
            left: 180,
            width: 150,
            height: 150,
            colors: <Color>[
              const Color(0x20E4CEAF),
              const Color(0x00E4CEAF),
            ],
          ),
          _buildBackgroundAccent(
            top: 52,
            left: -18,
            width: 110,
            height: 110,
            colors: <Color>[
              const Color(0x10F7E8D1),
              const Color(0x00F7E8D1),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  _buildTopLabels(textTheme),
                  _buildActionButton(
                    icon: Icons.insights_outlined,
                    label: '期間サマリ',
                    onPressed: onPeriodSummaryPressed,
                  ),
                  _buildActionButton(
                    icon: Icons.calendar_month,
                    onPressed: onCalendarPressed,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                summaryLabel,
                style: textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFFE4D8C8),
                  fontSize: 14,
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
