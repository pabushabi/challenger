import 'package:flutter/material.dart';
import 'package:kinochallenge/core/utils/challenge_stats.dart';
import 'package:kinochallenge/features/home/presentation/widgets/progress_arc.dart';
import 'package:kinochallenge/features/home/presentation/widgets/stat_tile.dart';

class ChallengeStatsSection extends StatelessWidget {
  const ChallengeStatsSection({
    super.key,
    required this.challengeName,
    required this.stats,
  });

  final String challengeName;
  final ChallengeStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: [
          Text(
            challengeName,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          ProgressArc(
            completed: stats.completed,
            target: stats.target,
            progress: stats.progress,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: StatTile(
                  label: 'Осталось дней',
                  value: '${stats.daysRemaining}',
                ),
              ),
              Expanded(
                child: StatTile(
                  label: 'Темп',
                  value: stats.paceLabel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: StatTile(
                  label: 'Прогноз',
                  value: '${stats.projectedCount}',
                ),
              ),
              Expanded(
                child: StatTile(
                  label: 'Оптимально',
                  value: stats.optimalPeriodicityLabel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
