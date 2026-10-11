import 'package:flutter/material.dart';
import 'package:kinochallenge/core/utils/challenge_stats.dart';
import 'package:kinochallenge/features/home/presentation/widgets/stat_tile.dart';

class ChallengeStatsCard extends StatelessWidget {
  const ChallengeStatsCard({super.key, required this.stats});

  final ChallengeStats stats;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
      ),
    );
  }
}
