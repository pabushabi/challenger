import 'package:flutter/material.dart';
import 'package:kinochallenge/core/utils/challenge_stats.dart';
import 'package:kinochallenge/features/home/presentation/widgets/challenge_stats_card.dart';

class ChallengeStatsSection extends StatelessWidget {
  const ChallengeStatsSection({
    super.key,
    required this.stats,
  });

  final ChallengeStats stats;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: ChallengeStatsCard(stats: stats),
    );
  }
}
