import 'package:flutter/material.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/settings_section_card.dart';

class SettingsThemeSection extends StatelessWidget {
  const SettingsThemeSection({
    super.key,
    required this.themeMode,
    required this.onChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SettingsSectionCard(
      title: 'Тема',
      subtitle: 'Светлая, тёмная или как в системе',
      child: SegmentedButton<ThemeMode>(
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
        onSelectionChanged: (value) => onChanged(value.first),
      ),
    );
  }
}
