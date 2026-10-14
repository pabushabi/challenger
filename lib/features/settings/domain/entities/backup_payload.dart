import 'package:flutter/material.dart';
import 'package:kinochallenge/features/challenge/domain/entities/challenge.dart';
import 'package:kinochallenge/features/challenge/domain/entities/challenge_event.dart';
import 'package:kinochallenge/features/challenge/domain/entities/event_field_def.dart';
import 'package:kinochallenge/features/challenge/domain/entities/field_type.dart';
import 'package:kinochallenge/features/settings/domain/entities/app_settings.dart';

class BackupPayload {
  const BackupPayload({
    required this.version,
    required this.exportedAt,
    required this.settings,
    required this.challenge,
  });

  static const int currentVersion = 1;

  final int version;
  final DateTime exportedAt;
  final AppSettings settings;
  final Challenge? challenge;

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'exportedAt': exportedAt.toIso8601String(),
      'settings': _settingsToJson(settings),
      'challenge': challenge == null ? null : _challengeToJson(challenge!),
    };
  }

  factory BackupPayload.fromJson(Map<String, dynamic> json) {
    final version = json['version'] as int? ?? 0;
    if (version != currentVersion) {
      throw const FormatException('Неподдерживаемая версия бэкапа');
    }

    final settingsJson = json['settings'];
    if (settingsJson is! Map<String, dynamic>) {
      throw const FormatException('В бэкапе нет настроек');
    }

    final challengeJson = json['challenge'];
    return BackupPayload(
      version: version,
      exportedAt: DateTime.tryParse(json['exportedAt'] as String? ?? '') ??
          DateTime.now(),
      settings: _settingsFromJson(settingsJson),
      challenge: challengeJson is Map<String, dynamic>
          ? _challengeFromJson(challengeJson)
          : null,
    );
  }

  static Map<String, dynamic> _settingsToJson(AppSettings settings) {
    return {
      'vibrationEnabled': settings.vibrationEnabled,
      'themeMode': settings.themeMode.name,
      'accentColorIndex': settings.accentColorIndex,
      'notificationsEnabled': settings.notificationsEnabled,
      'notificationSlot': settings.notificationSlot.name,
    };
  }

  static AppSettings _settingsFromJson(Map<String, dynamic> json) {
    final defaults = AppSettings.defaults();
    return AppSettings(
      vibrationEnabled:
          json['vibrationEnabled'] as bool? ?? defaults.vibrationEnabled,
      themeMode: ThemeMode.values.firstWhere(
        (e) => e.name == json['themeMode'],
        orElse: () => defaults.themeMode,
      ),
      accentColorIndex:
          json['accentColorIndex'] as int? ?? defaults.accentColorIndex,
      notificationsEnabled: json['notificationsEnabled'] as bool? ??
          defaults.notificationsEnabled,
      notificationSlot: NotificationSlot.fromName(
        json['notificationSlot'] as String? ?? defaults.notificationSlot.name,
      ),
    );
  }

  static Map<String, dynamic> _challengeToJson(Challenge challenge) {
    return {
      'id': challenge.id,
      'name': challenge.name,
      'targetCount': challenge.targetCount,
      'startDate': challenge.startDate.toIso8601String(),
      'endDate': challenge.endDate.toIso8601String(),
      'isActive': challenge.isActive,
      'fieldDefs': challenge.fieldDefs
          .map(
            (f) => {
              'id': f.id,
              'challengeId': f.challengeId,
              'label': f.label,
              'type': f.type.name,
              'isDefault': f.isDefault,
              'sortOrder': f.sortOrder,
            },
          )
          .toList(),
      'events': challenge.events
          .map(
            (e) => {
              'id': e.id,
              'challengeId': e.challengeId,
              'createdAt': e.createdAt.toIso8601String(),
              'values': e.values,
            },
          )
          .toList(),
    };
  }

  static Challenge _challengeFromJson(Map<String, dynamic> json) {
    final id = json['id'] as String?;
    final name = json['name'] as String?;
    final targetCount = json['targetCount'] as int?;
    final startDate = DateTime.tryParse(json['startDate'] as String? ?? '');
    final endDate = DateTime.tryParse(json['endDate'] as String? ?? '');

    if (id == null ||
        name == null ||
        targetCount == null ||
        startDate == null ||
        endDate == null) {
      throw const FormatException('Повреждённые данные челленджа в бэкапе');
    }

    final fieldDefsJson = json['fieldDefs'];
    final eventsJson = json['events'];

    final fieldDefs = <EventFieldDef>[];
    if (fieldDefsJson is List) {
      for (final item in fieldDefsJson) {
        if (item is! Map<String, dynamic>) {
          continue;
        }
        final fieldId = item['id'] as String?;
        final challengeId = item['challengeId'] as String? ?? id;
        final label = item['label'] as String?;
        if (fieldId == null || label == null) {
          continue;
        }
        fieldDefs.add(
          EventFieldDef(
            id: fieldId,
            challengeId: challengeId,
            label: label,
            type: FieldType.fromName(item['type'] as String? ?? 'text'),
            isDefault: item['isDefault'] as bool? ?? false,
            sortOrder: item['sortOrder'] as int? ?? 0,
          ),
        );
      }
    }

    final events = <ChallengeEvent>[];
    if (eventsJson is List) {
      for (final item in eventsJson) {
        if (item is! Map<String, dynamic>) {
          continue;
        }
        final eventId = item['id'] as String?;
        final createdAt =
            DateTime.tryParse(item['createdAt'] as String? ?? '');
        if (eventId == null || createdAt == null) {
          continue;
        }
        final rawValues = item['values'];
        final values = <String, String>{};
        if (rawValues is Map) {
          rawValues.forEach((key, value) {
            values['$key'] = '$value';
          });
        }
        events.add(
          ChallengeEvent(
            id: eventId,
            challengeId: item['challengeId'] as String? ?? id,
            createdAt: createdAt,
            values: values,
          ),
        );
      }
    }

    return Challenge(
      id: id,
      name: name,
      targetCount: targetCount,
      startDate: startDate,
      endDate: endDate,
      isActive: json['isActive'] as bool? ?? true,
      fieldDefs: fieldDefs,
      events: events,
    );
  }
}
