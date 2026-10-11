import 'package:flutter/material.dart';
import 'package:kinochallenge/core/utils/challenge_stats.dart';
import 'package:kinochallenge/features/home/presentation/widgets/challenge_stats_card.dart';
import 'package:kinochallenge/features/home/presentation/widgets/progress_arc.dart';

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Column(
        children: [
          ProgressArc(
            challengeName: challengeName,
            completed: stats.completed,
            target: stats.target,
            progress: stats.progress,
          ),
          const SizedBox(height: 12),
          ChallengeStatsCard(stats: stats),
        ],
      ),
    );
  }
}
