import 'dart:math' as math;

import 'package:flutter/material.dart';

enum ProgressArcLayout {
  /// Для экрана приложения — чуть ниже, с запасом под текст.
  app,

  /// Для виджета — плотнее к краям, без лишнего верха.
  widget,
}

class ProgressArcPainter extends CustomPainter {
  ProgressArcPainter({
    required this.progress,
    required this.foreground,
    required this.background,
    this.strokeWidth = 16,
    this.layout = ProgressArcLayout.app,
  });

  final double progress;
  final Color foreground;
  final Color background;
  final double strokeWidth;
  final ProgressArcLayout layout;

  /// Спидометр: от ~7:30 до ~4:30 через верх (~270°).
  static const double startAngle = math.pi * 0.75;
  static const double sweepAngle = math.pi * 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    final inset = strokeWidth / 2 + 2;
    final double centerY;
    final double radius;

    if (layout == ProgressArcLayout.widget) {
      // Вертикальный охват дуги ≈ 1.707 * r; прижимаем к верху без клиппинга.
      final maxRadius = math.min(
        (size.width / 2) - inset,
        (size.height - inset * 2) / 1.72,
      );
      radius = maxRadius;
      centerY = inset + radius;
    } else {
      centerY = size.height * 0.56;
      radius = math.min(size.width / 2, size.height * 0.52) - inset;
    }

    final center = Offset(size.width / 2, centerY);

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
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.layout != layout;
  }
}
