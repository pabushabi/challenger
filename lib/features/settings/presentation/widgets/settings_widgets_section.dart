import 'package:flutter/material.dart';

class SettingsWidgetsSection extends StatelessWidget {
  const SettingsWidgetsSection({
    super.key,
    required this.onAddWidget,
  });

  final VoidCallback onAddWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Виджеты',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Доступны размеры 1×1, 1×2, 1×4, 2×2 и 2×4.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: OutlinedButton.icon(
            onPressed: onAddWidget,
            icon: const Icon(Icons.widgets_outlined),
            label: const Text('Добавить виджет'),
          ),
        ),
      ],
    );
  }
}
