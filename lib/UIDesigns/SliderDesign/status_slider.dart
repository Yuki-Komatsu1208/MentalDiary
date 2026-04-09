import 'package:mental_diary/UIDesigns/SliderDesign/slider_designs';
import 'package:flutter/material.dart';

//状態入力用のスライダーUI
class StatusSlider extends StatelessWidget {
  const StatusSlider({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    required this.currentValueLabel,
    required this.minHint,
    required this.maxHint,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final String currentValueLabel;
  final String minHint;
  final String maxHint;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F3EA),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF3B342D), width: 1),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF171411),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  currentValueLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackShape: const RectangularSliderTrackShape(),
              trackHeight: 3.2,
              activeTrackColor: const Color(0xFF171411),
              inactiveTrackColor: const Color(0xFFCFC2AE),
              thumbColor: const Color(0xFF171411),
              overlayColor: const Color(0x14111111),
              valueIndicatorColor: const Color(0xFF171411),
              valueIndicatorTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              thumbShape: const DiamondSliderThumbShape(thumbSize: 10.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
            ),
            child: Slider(
              value: value.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: value.toString(),
              onChanged: (double newValue) {
                onChanged(newValue.round());
              },
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  minHint,
                  style: const TextStyle(
                    color: Color(0xFF665E55),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  maxHint,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xFF665E55),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
