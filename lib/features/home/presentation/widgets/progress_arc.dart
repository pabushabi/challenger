import 'package:flutter/material.dart';
import 'package:kinochallenge/features/home/presentation/widgets/progress_arc_painter.dart';

class ProgressArc extends StatelessWidget {
  const ProgressArc({
    super.key,
    required this.challengeName,
    required this.completed,
    required this.target,
    required this.progress,
  });

  final String challengeName;
  final int completed;
  final int target;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 260,
      width: double.infinity,
      child: CustomPaint(
        painter: ProgressArcPainter(
          progress: progress,
          foreground: scheme.primary,
          background: scheme.surfaceContainerHighest,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 52, 24, 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                challengeName,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$completed / $target',
                style: textTheme.headlineMedium?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
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
    );
  }
}
