import 'package:flutter/material.dart';
import 'package:kinochallenge/features/settings/domain/entities/app_settings.dart';

class SettingsNotificationsSection extends StatelessWidget {
  const SettingsNotificationsSection({
    super.key,
    required this.enabled,
    required this.slot,
    required this.onEnabledChanged,
    required this.onSlotChanged,
  });

  final bool enabled;
  final NotificationSlot slot;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<NotificationSlot> onSlotChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Уведомления',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SwitchListTile(
          title: const Text('Напоминания'),
          subtitle: const Text(
            'С оптимальной периодичностью выполнения челленджа',
          ),
          value: enabled,
          onChanged: onEnabledChanged,
        ),
        if (enabled)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: SegmentedButton<NotificationSlot>(
              segments: [
                for (final value in NotificationSlot.values)
                  ButtonSegment(
                    value: value,
                    label: Text(value.labelRu),
                  ),
              ],
              selected: {slot},
              onSelectionChanged: (value) => onSlotChanged(value.first),
            ),
          ),
      ],
    );
  }
}
