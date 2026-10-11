import 'dart:math' as math;

import 'package:flutter/material.dart';

class ProgressArcPainter extends CustomPainter {
  ProgressArcPainter({
    required this.progress,
    required this.foreground,
    required this.background,
    this.strokeWidth = 14,
  });

  final double progress;
  final Color foreground;
  final Color background;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.72);
    final radius = math.min(size.width / 2, size.height) - strokeWidth;

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

    const startAngle = math.pi * 1.05;
    const sweepAngle = math.pi * 0.9;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
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
