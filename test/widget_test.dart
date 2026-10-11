import 'package:flutter_test/flutter_test.dart';
import 'package:kinochallenge/core/utils/challenge_stats.dart';

void main() {
  test('ChallengeStats calculates remaining days and periodicity', () {
    final stats = ChallengeStats(
      completed: 10,
      target: 100,
      startDate: DateTime(2026, 1, 1),
      endDate: DateTime(2026, 12, 31),
      now: DateTime(2026, 1, 11),
    );

    expect(stats.daysRemaining, greaterThan(0));
    expect(stats.remainingEvents, 90);
    expect(stats.optimalPeriodicityLabel, isNotEmpty);
    expect(stats.projectedCount, greaterThan(0));
  });
}
