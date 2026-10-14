import 'package:flutter/material.dart';
import 'package:kinochallenge/features/settings/domain/entities/backup_export_mode.dart';

class BackupExportSheet extends StatelessWidget {
  const BackupExportSheet({super.key});

  static Future<BackupExportMode?> show(BuildContext context) {
    return showModalBottomSheet<BackupExportMode>(
      context: context,
      showDragHandle: true,
      builder: (_) => const BackupExportSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Куда сохранить бэкап?',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Можно сохранить файл на устройство или отправить через другое приложение',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              tileColor: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
              leading: Icon(Icons.folder_outlined, color: scheme.primary),
              title: const Text('Сохранить на устройство'),
              subtitle: const Text('Выбрать папку в Файлах'),
              onTap: () => Navigator.pop(context, BackupExportMode.saveToDevice),
            ),
            const SizedBox(height: 10),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              tileColor: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
              leading: Icon(Icons.share_outlined, color: scheme.primary),
              title: const Text('Поделиться'),
              subtitle: const Text('Мессенджер, почта и другие приложения'),
              onTap: () => Navigator.pop(context, BackupExportMode.share),
            ),
          ],
        ),
      ),
    );
  }
}
