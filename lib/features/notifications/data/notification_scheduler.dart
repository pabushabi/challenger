import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kinochallenge/core/utils/challenge_stats.dart';
import 'package:kinochallenge/features/challenge/domain/entities/challenge.dart';
import 'package:kinochallenge/features/settings/domain/entities/app_settings.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationScheduler {
  NotificationScheduler(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;
  static const _notificationId = 1001;
  static const _channelId = 'challenger_reminders';
  static const _channelName = 'Напоминания челленджа';

  Future<void> initialize() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Moscow'));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);

    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'Напоминания с оптимальной периодичностью',
      importance: Importance.defaultImportance,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> requestPermission() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> reschedule({
    required AppSettings settings,
    required Challenge? challenge,
  }) async {
    await _plugin.cancel(_notificationId);

    if (!settings.notificationsEnabled || challenge == null) {
      return;
    }

    final stats = ChallengeStats(
      completed: challenge.completedCount,
      target: challenge.targetCount,
      startDate: challenge.startDate,
      endDate: challenge.endDate,
      now: DateTime.now(),
    );

    final intervalDays = stats.notificationIntervalDays;
    if (intervalDays <= 0) {
      return;
    }

    await requestPermission();

    final scheduled = _nextSlot(
      slot: settings.notificationSlot,
      intervalDays: intervalDays,
    );

    await _plugin.zonedSchedule(
      _notificationId,
      'CHALLENGER',
      'Пора отметить прогресс в «${challenge.name}»',
      scheduled,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: 'Напоминания с оптимальной периодичностью',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  tz.TZDateTime _nextSlot({
    required NotificationSlot slot,
    required int intervalDays,
  }) {
    final now = tz.TZDateTime.now(tz.local);
    var candidate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      slot.hour,
    );

    if (!candidate.isAfter(now)) {
      candidate = candidate.add(Duration(days: intervalDays));
    }

    return candidate;
  }
}
