import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:kinochallenge/features/home/presentation/widgets/progress_morph_painter.dart';

class MorphingProgressArc extends StatelessWidget {
  const MorphingProgressArc({
    super.key,
    required this.challengeName,
    required this.completed,
    required this.target,
    required this.progress,
    required this.collapse,
  });

  final String challengeName;
  final int completed;
  final int target;
  final double progress;
  final double collapse;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final t = Curves.easeInOutCubic.transform(collapse.clamp(0.0, 1.0));
    final expandedOpacity = (1 - t * 1.4).clamp(0.0, 1.0);
    final collapsedOpacity = ((t - 0.45) / 0.55).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          painter: ProgressMorphPainter(
            progress: progress,
            collapse: collapse,
            foreground: scheme.primary,
            background: scheme.surfaceContainerHighest,
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: expandedOpacity,
                  child: IgnorePointer(
                    ignoring: t > 0.2,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        24,
                        lerpDouble(52, 8, t)!,
                        24,
                        24,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                            textAlign: TextAlign.center,
                            style: textTheme.headlineMedium?.copyWith(
                              color: scheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'выполнено',
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: collapsedOpacity,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: SizedBox(
                      width: constraints.maxWidth * 0.25,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            challengeName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleSmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$completed / $target',
                            style: textTheme.titleMedium?.copyWith(
                              color: scheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
