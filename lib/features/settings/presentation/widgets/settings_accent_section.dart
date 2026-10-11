import 'package:flutter/material.dart';
import 'package:kinochallenge/core/theme/app_colors.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/accent_color_dot.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Главный цвет',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (var i = 0; i < AppColors.accentPalette.length; i++)
                AccentColorDot(
                  color: AppColors.accentPalette[i],
                  selected: i == selectedIndex,
                  onTap: () => onSelected(i),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
