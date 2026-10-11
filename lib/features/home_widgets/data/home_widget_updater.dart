import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:home_widget/home_widget.dart';
import 'package:kinochallenge/core/theme/app_colors.dart';
import 'package:kinochallenge/core/utils/challenge_stats.dart';
import 'package:kinochallenge/features/challenge/domain/entities/challenge.dart';
import 'package:kinochallenge/features/home_widgets/presentation/widgets/widget_progress_arc.dart';
import 'package:kinochallenge/features/settings/data/settings_repository.dart';

class HomeWidgetUpdater {
  HomeWidgetUpdater(this._settingsRepository);

  final SettingsRepository _settingsRepository;

  static const providers = [
    'Widget1x1Provider',
    'Widget1x2Provider',
    'Widget2x2Provider',
    'Widget1x4Provider',
    'Widget2x4Provider',
  ];

  static const arcImageKey = 'widget_arc';
  static const arcTitledImageKey = 'widget_arc_titled';

  Future<void> initialize() async {
    await HomeWidget.setAppGroupId('com.pabushabi.challenger');
  }

  Future<void> update(Challenge? challenge) async {
    final title = challenge?.name ?? 'CHALLENGER';

    if (challenge == null) {
      await HomeWidget.saveWidgetData<String>('title', title);
      await HomeWidget.saveWidgetData<String>('progress', '—');
      await HomeWidget.saveWidgetData<int>('completed', 0);
      await HomeWidget.saveWidgetData<int>('target', 0);
      await HomeWidget.saveWidgetData<int>('daysLeft', 0);
      await HomeWidget.saveWidgetData<String>('pace', '—');
      await HomeWidget.saveWidgetData<String>('projected', '—');
      await HomeWidget.saveWidgetData<String>('periodicity', '—');
      await HomeWidget.saveWidgetData<int>('progressPercent', 0);
      await _renderArcs(
        title: title,
        progress: 0,
        completed: 0,
        target: 0,
        daysLeft: 0,
      );
    } else {
      final stats = ChallengeStats(
        completed: challenge.completedCount,
        target: challenge.targetCount,
        startDate: challenge.startDate,
        endDate: challenge.endDate,
        now: DateTime.now(),
      );

      await HomeWidget.saveWidgetData<String>('title', title);
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
      await _renderArcs(
        title: title,
        progress: stats.progress,
        completed: stats.completed,
        target: stats.target,
        daysLeft: stats.daysRemaining,
      );
    }

    for (final provider in providers) {
      await HomeWidget.updateWidget(name: provider, androidName: provider);
    }
  }

  Future<void> _renderArcs({
    required String title,
    required double progress,
    required int completed,
    required int target,
    required int daysLeft,
  }) async {
    final settings = _settingsRepository.load();
    final isDark =
        SchedulerBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
    final foreground = AppColors.accentByIndex(settings.accentColorIndex);
    final track = isDark ? const Color(0xFF3F3F46) : const Color(0xFFD8D8DE);
    final label = isDark ? const Color(0xFFF2F2F4) : const Color(0xFF1A1A1C);
    final secondary = isDark ? const Color(0xFFB0B0B8) : const Color(0xFF6B6B73);
    const arcSize = Size(360, 360);

    Future<void> render({
      required String key,
      String? arcTitle,
    }) async {
      try {
        await HomeWidget.renderFlutterWidget(
          WidgetProgressArc(
            title: arcTitle,
            progress: progress,
            completed: completed,
            target: target,
            daysLeft: daysLeft,
            foreground: foreground,
            background: track,
            labelColor: label,
            secondaryLabelColor: secondary,
            size: arcSize,
            strokeWidth: 24,
          ),
          key: key,
          logicalSize: arcSize,
        );
      } catch (_) {
        // Виджеты 1×N продолжат работать без арки.
      }
    }

    await render(key: arcImageKey);
    await render(key: arcTitledImageKey, arcTitle: title);
  }

  Future<void> requestPin() async {
    await HomeWidget.requestPinWidget(
      name: providers.first,
      androidName: providers.first,
    );
  }
}
