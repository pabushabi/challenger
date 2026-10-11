import 'package:flutter/material.dart';
import 'package:kinochallenge/features/home/presentation/widgets/progress_arc_painter.dart';

class WidgetProgressArc extends StatelessWidget {
  const WidgetProgressArc({
    super.key,
    required this.progress,
    required this.completed,
    required this.target,
    required this.foreground,
    required this.background,
    required this.labelColor,
    required this.secondaryLabelColor,
    this.title,
    this.daysLeft,
    this.size = const Size(360, 360),
    this.strokeWidth = 22,
  });

  final double progress;
  final int completed;
  final int target;
  final Color foreground;
  final Color background;
  final Color labelColor;
  final Color secondaryLabelColor;
  final String? title;
  final int? daysLeft;
  final Size size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final hasTitle = title != null && title!.trim().isNotEmpty;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: CustomPaint(
        size: size,
        painter: ProgressArcPainter(
          progress: progress,
          foreground: foreground,
          background: background,
          strokeWidth: strokeWidth,
          layout: ProgressArcLayout.widget,
        ),
        child: Align(
          alignment: Alignment(0, hasTitle ? 0.18 : 0.22),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasTitle) ...[
                  Text(
                    title!.trim(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: secondaryLabelColor,
                      fontSize: size.width * 0.048,
                      fontWeight: FontWeight.w600,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
                Text(
                  '$completed / $target',
                  style: TextStyle(
                    color: labelColor,
                    fontSize: size.width * (hasTitle ? 0.1 : 0.11),
                    fontWeight: FontWeight.w700,
                    height: 1.05,
                  ),
                ),
                if (daysLeft != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Осталось: $daysLeft дн.',
                    style: TextStyle(
                      color: secondaryLabelColor,
                      fontSize: size.width * 0.045,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
