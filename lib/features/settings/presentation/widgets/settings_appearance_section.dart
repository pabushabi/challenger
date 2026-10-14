import 'package:flutter/material.dart';
import 'package:kinochallenge/core/theme/app_colors.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/accent_color_dot.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/settings_section_card.dart';

class SettingsAppearanceSection extends StatelessWidget {
  const SettingsAppearanceSection({
    super.key,
    required this.themeMode,
    required this.accentIndex,
    required this.vibrationEnabled,
    required this.onThemeChanged,
    required this.onAccentSelected,
    required this.onVibrationChanged,
  });

  final ThemeMode themeMode;
  final int accentIndex;
  final bool vibrationEnabled;
  final ValueChanged<ThemeMode> onThemeChanged;
  final ValueChanged<int> onAccentSelected;
  final ValueChanged<bool> onVibrationChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SettingsSectionCard(
      title: 'Оформление',
      subtitle: 'Тема, цвет и отклик при добавлении отметки',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Тема',
            style: theme.textTheme.labelLarge?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                value: ThemeMode.light,
                label: Text('Светлая'),
                icon: Icon(Icons.light_mode_outlined),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text('Тёмная'),
                icon: Icon(Icons.dark_mode_outlined),
              ),
              ButtonSegment(
                value: ThemeMode.system,
                label: Text('Система'),
                icon: Icon(Icons.settings_suggest_outlined),
              ),
            ],
            selected: {themeMode},
            onSelectionChanged: (value) => onThemeChanged(value.first),
          ),
          const SizedBox(height: 20),
          Text(
            'Главный цвет',
            style: theme.textTheme.labelLarge?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (var i = 0; i < AppColors.accentPalette.length; i++)
                AccentColorDot(
                  color: AppColors.accentPalette[i],
                  selected: i == accentIndex,
                  onTap: () => onAccentSelected(i),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Material(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(14),
            child: SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              title: Text(
                'Вибрация',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                vibrationEnabled ? 'Включена' : 'Выключена',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              value: vibrationEnabled,
              onChanged: onVibrationChanged,
            ),
          ),
        ],
      ),
    );
  }
}
