import 'package:flutter/material.dart';
import 'package:kinochallenge/features/home/presentation/widgets/progress_arc_painter.dart';

class ProgressArc extends StatelessWidget {
  const ProgressArc({
    super.key,
    required this.completed,
    required this.target,
    required this.progress,
  });

  final int completed;
  final int target;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 180,
      width: double.infinity,
      child: CustomPaint(
        painter: ProgressArcPainter(
          progress: progress,
          foreground: scheme.primary,
          background: scheme.surfaceContainerHighest,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$completed / $target',
                  style: textTheme.headlineMedium?.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
                Text(
                  'выполнено',
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
