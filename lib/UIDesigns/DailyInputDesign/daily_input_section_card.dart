import 'package:flutter/material.dart';

//日次入力画面のセクションカードUI
class DailyInputSectionCard extends StatelessWidget {
  const DailyInputSectionCard({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.child,
  });

  final String eyebrow;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF111111), width: 1.1),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 16,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            eyebrow,
            style: textTheme.titleMedium?.copyWith(
              fontSize: 11,
              letterSpacing: 1.4,
              color: const Color(0xFF6A6A6A),
            ),
          ),
          const SizedBox(height: 8),
          Text(title, style: textTheme.headlineMedium),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}
