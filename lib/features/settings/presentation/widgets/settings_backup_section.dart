import 'package:flutter/material.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/settings_section_card.dart';

class SettingsBackupSection extends StatelessWidget {
  const SettingsBackupSection({
    super.key,
    required this.onBackup,
    required this.onRestore,
    this.busy = false,
  });

  final VoidCallback onBackup;
  final VoidCallback onRestore;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return SettingsSectionCard(
      title: 'Резервная копия',
      subtitle:
          'Сохраните челлендж, историю выполнения и настройки в файл или восстановите их из бэкапа',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.tonalIcon(
            onPressed: busy ? null : onBackup,
            icon: const Icon(Icons.upload_outlined),
            label: const Text('Создать бэкап'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: busy ? null : onRestore,
            icon: const Icon(Icons.download_outlined),
            label: const Text('Восстановить из бэкапа'),
          ),
        ],
      ),
    );
  }
}
