import 'package:flutter/material.dart';
import 'package:kinochallenge/features/settings/domain/entities/app_settings.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/settings_section_card.dart';

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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SettingsSectionCard(
      title: 'Уведомления',
      subtitle: 'С оптимальной периодичностью выполнения челленджа',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(14),
            child: SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              title: Text(
                'Напоминания',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                enabled ? 'Включены' : 'Выключены',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              value: enabled,
              onChanged: onEnabledChanged,
            ),
          ),
          if (enabled) ...[
            const SizedBox(height: 12),
            Text(
              'Время дня',
              style: theme.textTheme.labelLarge?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            SegmentedButton<NotificationSlot>(
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
          ],
        ],
      ),
    );
  }
}
