import 'package:flutter/material.dart';
import 'package:kinochallenge/core/theme/app_colors.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/accent_color_dot.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/settings_section_card.dart';

class SettingsAccentSection extends StatelessWidget {
  const SettingsAccentSection({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SettingsSectionCard(
      title: 'Главный цвет',
      subtitle: 'Фирменный акцент приложения',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (var i = 0; i < AppColors.accentPalette.length; i++)
            AccentColorDot(
              color: AppColors.accentPalette[i],
              selected: i == selectedIndex,
              onTap: () => onSelected(i),
            ),
        ],
      ),
    );
  }
}
