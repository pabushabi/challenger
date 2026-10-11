import 'dart:math' as math;

import 'package:flutter/material.dart';

class ProgressArcPainter extends CustomPainter {
  ProgressArcPainter({
    required this.progress,
    required this.foreground,
    required this.background,
    this.strokeWidth = 16,
  });

  final double progress;
  final Color foreground;
  final Color background;
  final double strokeWidth;

  /// Спидометр: от ~7:30 до ~4:30 через верх (~270°).
  static const double startAngle = math.pi * 0.75;
  static const double sweepAngle = math.pi * 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.58);
    final radius =
        math.min(size.width / 2, size.height * 0.52) - strokeWidth / 2;

    final bgPaint = Paint()
      ..color = background
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..color = foreground
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(rect, startAngle, sweepAngle, false, bgPaint);
    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle * progress.clamp(0.0, 1.0),
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ProgressArcPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.foreground != foreground ||
        oldDelegate.background != background ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
