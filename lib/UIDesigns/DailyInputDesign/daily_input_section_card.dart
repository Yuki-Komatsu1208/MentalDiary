import 'package:flutter/material.dart';

//日次入力画面のセクションカードUI
class DailyInputSectionCard extends StatelessWidget {
  const DailyInputSectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: textTheme.headlineMedium),
        const SizedBox(height: 18),
        child,
      ],
    );
  }
}
