import 'package:flutter/material.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/settings_section_card.dart';

class SettingsVibrationTile extends StatelessWidget {
  const SettingsVibrationTile({
    super.key,
    required this.enabled,
    required this.onChanged,
  });

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SettingsSectionCard(
      title: 'Вибрация',
      subtitle: 'Отклик при добавлении отметки',
      child: Material(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(14),
        child: SwitchListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          title: Text(
            enabled ? 'Включена' : 'Выключена',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          value: enabled,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
