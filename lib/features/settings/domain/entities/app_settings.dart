import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum NotificationSlot {
  morning,
  day,
  evening;

  String get labelRu {
    switch (this) {
      case NotificationSlot.morning:
        return 'Утро';
      case NotificationSlot.day:
        return 'День';
      case NotificationSlot.evening:
        return 'Вечер';
    }
  }

  int get hour {
    switch (this) {
      case NotificationSlot.morning:
        return 9;
      case NotificationSlot.day:
        return 14;
      case NotificationSlot.evening:
        return 20;
    }
  }

  static NotificationSlot fromName(String name) {
    return NotificationSlot.values.firstWhere(
      (e) => e.name == name,
      orElse: () => NotificationSlot.morning,
    );
  }
}

class AppSettings extends Equatable {
  const AppSettings({
    required this.vibrationEnabled,
    required this.themeMode,
    required this.accentColorIndex,
    required this.notificationsEnabled,
    required this.notificationSlot,
  });

  final bool vibrationEnabled;
  final ThemeMode themeMode;
  final int accentColorIndex;
  final bool notificationsEnabled;
  final NotificationSlot notificationSlot;

  factory AppSettings.defaults() => const AppSettings(
        vibrationEnabled: true,
        themeMode: ThemeMode.system,
        accentColorIndex: 0,
        notificationsEnabled: false,
        notificationSlot: NotificationSlot.morning,
      );

  AppSettings copyWith({
    bool? vibrationEnabled,
    ThemeMode? themeMode,
    int? accentColorIndex,
    bool? notificationsEnabled,
    NotificationSlot? notificationSlot,
  }) {
    return AppSettings(
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      themeMode: themeMode ?? this.themeMode,
      accentColorIndex: accentColorIndex ?? this.accentColorIndex,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationSlot: notificationSlot ?? this.notificationSlot,
    );
  }

  @override
  List<Object?> get props => [
        vibrationEnabled,
        themeMode,
        accentColorIndex,
        notificationsEnabled,
        notificationSlot,
      ];
}
