import 'package:flutter/material.dart';
import 'package:kinochallenge/features/home/presentation/widgets/morphing_progress_arc.dart';

class CollapsingProgressHeader extends StatelessWidget {
  const CollapsingProgressHeader({
    super.key,
    required this.challengeName,
    required this.completed,
    required this.target,
    required this.progress,
  });

  static const double maxExtent = 268;
  static const double minExtent = 72;

  final String challengeName;
  final int completed;
  final int target;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: CollapsingProgressHeaderDelegate(
        challengeName: challengeName,
        completed: completed,
        target: target,
        progress: progress,
      ),
    );
  }
}

class CollapsingProgressHeaderDelegate extends SliverPersistentHeaderDelegate {
  CollapsingProgressHeaderDelegate({
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
  double get maxExtent => CollapsingProgressHeader.maxExtent;

  @override
  double get minExtent => CollapsingProgressHeader.minExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final range = maxExtent - minExtent;
    final collapse = range <= 0 ? 1.0 : (shrinkOffset / range).clamp(0.0, 1.0);
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        boxShadow: collapse > 0.85
            ? [
                BoxShadow(
                  color: scheme.shadow.withValues(alpha: 0.08 * collapse),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
        child: MorphingProgressArc(
          challengeName: challengeName,
          completed: completed,
          target: target,
          progress: progress,
          collapse: collapse,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant CollapsingProgressHeaderDelegate oldDelegate) {
    return oldDelegate.challengeName != challengeName ||
        oldDelegate.completed != completed ||
        oldDelegate.target != target ||
        oldDelegate.progress != progress;
  }
}
