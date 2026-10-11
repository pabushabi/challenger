import 'package:flutter/material.dart';
import 'package:kinochallenge/features/settings/domain/entities/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _keyVibration = 'vibrationEnabled';
  static const _keyThemeMode = 'themeMode';
  static const _keyAccent = 'accentColorIndex';
  static const _keyNotifications = 'notificationsEnabled';
  static const _keyNotificationSlot = 'notificationTimeOfDay';

  AppSettings load() {
    final defaults = AppSettings.defaults();
    return AppSettings(
      vibrationEnabled: _prefs.getBool(_keyVibration) ?? defaults.vibrationEnabled,
      themeMode: _themeModeFromName(
        _prefs.getString(_keyThemeMode) ?? defaults.themeMode.name,
      ),
      accentColorIndex: _prefs.getInt(_keyAccent) ?? defaults.accentColorIndex,
      notificationsEnabled:
          _prefs.getBool(_keyNotifications) ?? defaults.notificationsEnabled,
      notificationSlot: NotificationSlot.fromName(
        _prefs.getString(_keyNotificationSlot) ?? defaults.notificationSlot.name,
      ),
    );
  }

  Future<void> save(AppSettings settings) async {
    await _prefs.setBool(_keyVibration, settings.vibrationEnabled);
    await _prefs.setString(_keyThemeMode, settings.themeMode.name);
    await _prefs.setInt(_keyAccent, settings.accentColorIndex);
    await _prefs.setBool(_keyNotifications, settings.notificationsEnabled);
    await _prefs.setString(
      _keyNotificationSlot,
      settings.notificationSlot.name,
    );
  }

  ThemeMode _themeModeFromName(String name) {
    return ThemeMode.values.firstWhere(
      (e) => e.name == name,
      orElse: () => ThemeMode.system,
    );
  }
}
