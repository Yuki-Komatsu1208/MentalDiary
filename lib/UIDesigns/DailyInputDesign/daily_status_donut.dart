import 'dart:math' as math;

import 'package:mental_diary/Entities/daily_status.dart';
import 'package:flutter/material.dart';

//日次状態を多層ドーナツで表示するUI
class DailyStatusDonut extends StatelessWidget {
  const DailyStatusDonut({super.key, required this.status, this.size = 28});

  final DailyStatus status;
  final double size;

  //ドーナツ描画用のリング情報一覧を返す
  List<_DonutRingData> _buildRings() {
    return <_DonutRingData>[
      _DonutRingData(
        progress: status.Mood.value / 5,
        color: const Color(0xFFE3CF9C),
      ),
      _DonutRingData(
        progress: status.Interest.value / 5,
        color: const Color(0xFF6F9272),
      ),
      _DonutRingData(
        progress: status.Energy.value / 5,
        color: const Color(0xFFC7812F),
      ),
      _DonutRingData(
        progress: status.SleepQuality.value / 5,
        color: const Color(0xFF5F78A6),
      ),
      _DonutRingData(
        progress: status.Stressed.value / 5,
        color: const Color(0xFFA13F3F),
      ),
    ];
  }

  //各リングの表示サイズ一覧を返す
  List<double> _buildRingSizes() {
    return <double>[size, size - 4, size - 12, size - 16, size -20];
  }

  @override
  Widget build(BuildContext context) {
    final List<_DonutRingData> rings = _buildRings();
    final List<double> ringSizes = _buildRingSizes();

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: List<Widget>.generate(rings.length, (int index) {
          final bool isStressCenter = index == rings.length - 1;
          return SizedBox(
            width: ringSizes[index],
            height: ringSizes[index],
            child: CustomPaint(
              painter: isStressCenter
                  ? _CenterStressCirclePainter(ring: rings[index])
                  : _SingleDonutRingPainter(ring: rings[index]),
            ),
          );
        }),
      ),
    );
  }
}

//ドーナツ1本分の描画情報
class _DonutRingData {
  const _DonutRingData({required this.progress, required this.color});

  final double progress;
  final Color color;
}

//単一ドーナツを描画するクラス
class _SingleDonutRingPainter extends CustomPainter {
  const _SingleDonutRingPainter({required this.ring});

  final _DonutRingData ring;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (math.min(size.width, size.height) / 2) - 1;
    const double strokeWidth = 5.2;

    final Paint backgroundPaint = Paint()
      ..color = ring.color.withValues(alpha: 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final Paint progressPaint = Paint()
      ..color = ring.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    if (ring.progress <= 0) {
      return;
    }

    final Rect arcRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(
      arcRect,
      -math.pi / 2,
      2 * math.pi * ring.progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SingleDonutRingPainter oldDelegate) {
    return oldDelegate.ring.progress != ring.progress ||
        oldDelegate.ring.color != ring.color;
  }
}

//中心のストレス値を塗り円で描画するクラス
class _CenterStressCirclePainter extends CustomPainter {
  const _CenterStressCirclePainter({required this.ring});

  final _DonutRingData ring;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (math.min(size.width, size.height) / 2) - 1;

    final Paint backgroundPaint = Paint()
      ..color = ring.color.withValues(alpha: 0.14)
      ..style = PaintingStyle.fill;

    final Paint foregroundPaint = Paint()
      ..color = ring.color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, backgroundPaint);

    if (ring.progress <= 0) {
      return;
    }

    canvas.drawCircle(
      center,
      radius * ring.progress.clamp(0.0, 1.0),
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CenterStressCirclePainter oldDelegate) {
    return oldDelegate.ring.progress != ring.progress ||
        oldDelegate.ring.color != ring.color;
  }
}
