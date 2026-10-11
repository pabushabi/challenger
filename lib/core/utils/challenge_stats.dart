import 'dart:math' as math;

class ChallengeStats {
  const ChallengeStats({
    required this.completed,
    required this.target,
    required this.startDate,
    required this.endDate,
    required this.now,
  });

  final int completed;
  final int target;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime now;

  DateTime get _startDay => DateTime(startDate.year, startDate.month, startDate.day);

  DateTime get _endDay => DateTime(endDate.year, endDate.month, endDate.day);

  DateTime get _nowDay => DateTime(now.year, now.month, now.day);

  int get totalDays {
    final days = _endDay.difference(_startDay).inDays + 1;
    return math.max(1, days);
  }

  int get daysElapsed {
    if (_nowDay.isBefore(_startDay)) {
      return 0;
    }
    final elapsed = _nowDay.difference(_startDay).inDays + 1;
    return math.min(elapsed, totalDays);
  }

  int get daysRemaining {
    if (_nowDay.isAfter(_endDay)) {
      return 0;
    }
    return math.max(0, _endDay.difference(_nowDay).inDays);
  }

  int get remainingEvents => math.max(0, target - completed);

  double get progress {
    if (target <= 0) {
      return 0;
    }
    return (completed / target).clamp(0.0, 1.0);
  }

  /// Событий в день.
  double get pace {
    final elapsed = math.max(1, daysElapsed);
    return completed / elapsed;
  }

  int get projectedCount => (pace * totalDays).round();

  /// Интервал в днях между одним событием. < 1 означает несколько в день.
  double? get optimalIntervalDays {
    if (remainingEvents <= 0) {
      return null;
    }
    final daysLeft = math.max(1, daysRemaining == 0 && remainingEvents > 0 ? 1 : daysRemaining);
    return daysLeft / remainingEvents;
  }

  String get optimalPeriodicityLabel {
    if (remainingEvents <= 0) {
      return 'Цель достигнута';
    }
    if (daysRemaining <= 0) {
      return 'Срок истёк';
    }

    final interval = optimalIntervalDays!;
    if (interval >= 1) {
      final days = interval.round().clamp(1, daysRemaining);
      if (days == 1) {
        return '1 раз в день';
      }
      return '1 раз в $days дн.';
    }

    final perDay = (1 / interval).ceil();
    if (perDay == 1) {
      return '1 раз в день';
    }
    return '$perDay в день';
  }

  String get paceLabel {
    if (completed == 0) {
      return '0 в день';
    }
    if (pace >= 1) {
      final value = pace.toStringAsFixed(pace >= 10 ? 0 : 1);
      return '$value в день';
    }
    final daysPerEvent = (1 / pace).round().clamp(1, 999);
    return '1 раз в $daysPerEvent дн.';
  }

  /// Минимальный интервал между уведомлениями в днях (не чаще 1 раза в день).
  int get notificationIntervalDays {
    final interval = optimalIntervalDays;
    if (interval == null) {
      return 0;
    }
    if (interval < 1) {
      return 1;
    }
    return interval.round().clamp(1, 365);
  }
}
