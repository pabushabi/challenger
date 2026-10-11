import 'package:home_widget/home_widget.dart';
import 'package:kinochallenge/core/utils/challenge_stats.dart';
import 'package:kinochallenge/features/challenge/domain/entities/challenge.dart';

class HomeWidgetUpdater {
  static const providers = [
    'Widget1x1Provider',
    'Widget1x2Provider',
    'Widget2x2Provider',
    'Widget1x4Provider',
    'Widget2x4Provider',
  ];

  Future<void> initialize() async {
    await HomeWidget.setAppGroupId('com.pabushabi.challenger');
  }

  Future<void> update(Challenge? challenge) async {
    if (challenge == null) {
      await HomeWidget.saveWidgetData<String>('title', 'CHALLENGER');
      await HomeWidget.saveWidgetData<String>('progress', '—');
      await HomeWidget.saveWidgetData<int>('completed', 0);
      await HomeWidget.saveWidgetData<int>('target', 0);
      await HomeWidget.saveWidgetData<int>('daysLeft', 0);
      await HomeWidget.saveWidgetData<String>('pace', '—');
      await HomeWidget.saveWidgetData<String>('projected', '—');
      await HomeWidget.saveWidgetData<String>('periodicity', '—');
      await HomeWidget.saveWidgetData<int>('progressPercent', 0);
    } else {
      final stats = ChallengeStats(
        completed: challenge.completedCount,
        target: challenge.targetCount,
        startDate: challenge.startDate,
        endDate: challenge.endDate,
        now: DateTime.now(),
      );

      await HomeWidget.saveWidgetData<String>('title', challenge.name);
      await HomeWidget.saveWidgetData<String>(
        'progress',
        '${stats.completed}/${stats.target}',
      );
      await HomeWidget.saveWidgetData<int>('completed', stats.completed);
      await HomeWidget.saveWidgetData<int>('target', stats.target);
      await HomeWidget.saveWidgetData<int>('daysLeft', stats.daysRemaining);
      await HomeWidget.saveWidgetData<String>('pace', stats.paceLabel);
      await HomeWidget.saveWidgetData<String>(
        'projected',
        '${stats.projectedCount}',
      );
      await HomeWidget.saveWidgetData<String>(
        'periodicity',
        stats.optimalPeriodicityLabel,
      );
      await HomeWidget.saveWidgetData<int>(
        'progressPercent',
        (stats.progress * 100).round(),
      );
    }

    for (final provider in providers) {
      await HomeWidget.updateWidget(name: provider, androidName: provider);
    }
  }

  Future<void> requestPin() async {
    await HomeWidget.requestPinWidget(
      name: providers.first,
      androidName: providers.first,
    );
  }
}
