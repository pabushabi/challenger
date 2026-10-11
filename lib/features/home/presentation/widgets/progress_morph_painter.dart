import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:kinochallenge/features/home/presentation/widgets/progress_arc_painter.dart';

class ProgressMorphPainter extends CustomPainter {
  ProgressMorphPainter({
    required this.progress,
    required this.collapse,
    required this.foreground,
    required this.background,
  });

  final double progress;
  final double collapse;
  final Color foreground;
  final Color background;

  static const double _arcStart = ProgressArcPainter.startAngle;
  static const double _arcSweep = ProgressArcPainter.sweepAngle;
  static const int _samples = 56;

  @override
  void paint(Canvas canvas, Size size) {
    final t = Curves.easeInOutCubic.transform(collapse.clamp(0.0, 1.0));
    final stroke = lerpDouble(16, 8, t)!;

    final points = List<Offset>.generate(
      _samples + 1,
      (i) => _morphPoint(i / _samples, size, stroke, t),
    );

    final bgPaint = Paint()
      ..color = background
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fgPaint = Paint()
      ..color = foreground
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(_pathThrough(points), bgPaint);

    final filled = progress.clamp(0.0, 1.0);
    if (filled > 0) {
      final steps = math.max(2, (filled * _samples).round());
      final fgPoints = List<Offset>.generate(
        steps + 1,
        (i) => _morphPoint((i / steps) * filled, size, stroke, t),
      );
      canvas.drawPath(_pathThrough(fgPoints), fgPaint);
    }
  }

  Offset _morphPoint(double u, Size size, double stroke, double t) {
    final arc = _arcPoint(u, size, stroke, t);
    final line = _linePoint(u, size, t);
    return Offset.lerp(arc, line, t)!;
  }

  Offset _arcPoint(double u, Size size, double stroke, double t) {
    final inset = stroke / 2 + 2;
    final baseRadius = math.min(size.width / 2, size.height * 0.52) - inset;
    // Growing radius flattens the curve while endpoints still lerp to the line.
    final radius = baseRadius * lerpDouble(1.0, 3.2, t)!;
    final center = Offset(
      lerpDouble(size.width / 2, size.width * 0.28, t)!,
      lerpDouble(size.height * 0.56, size.height / 2, t)!,
    );
    final angle = _arcStart + u * _arcSweep;
    return Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );
  }

  Offset _linePoint(double u, Size size, double t) {
    const pad = 8.0;
    final lineWidth = size.width * lerpDouble(0.55, 0.65, t)!;
    final y = size.height / 2;
    return Offset(pad + lineWidth * u, y);
  }

  Path _pathThrough(List<Offset> points) {
    final path = Path();
    if (points.isEmpty) {
      return path;
    }
    path.moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant ProgressMorphPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.collapse != collapse ||
        oldDelegate.foreground != foreground ||
        oldDelegate.background != background;
  }
}
