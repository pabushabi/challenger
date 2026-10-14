import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kinochallenge/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:kinochallenge/features/settings/presentation/cubit/theme_cubit.dart';
import 'package:kinochallenge/features/settings/domain/entities/backup_export_mode.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/backup_export_sheet.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/settings_appearance_section.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/settings_backup_section.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/settings_challenge_section.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/settings_fields_section.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/settings_group_header.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/settings_notifications_section.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/settings_widgets_section.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _backupBusy = false;

  Future<void> _onBackup() async {
    final mode = await BackupExportSheet.show(context);
    if (mode == null || !mounted) {
      return;
    }

    setState(() => _backupBusy = true);
    final result = await context.read<SettingsCubit>().exportBackup(mode);
    if (!mounted) {
      return;
    }
    setState(() => _backupBusy = false);

    if (result == null) {
      return;
    }
    if (!result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось создать бэкап')),
      );
      return;
    }

    final message = mode == BackupExportMode.saveToDevice
        ? 'Бэкап сохранён на устройство'
        : 'Бэкап отправлен';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _onRestore() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Восстановить бэкап?'),
        content: const Text(
          'Текущий челлендж, история и настройки будут заменены данными из файла.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Восстановить'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }

    setState(() => _backupBusy = true);
    final result = await context.read<SettingsCubit>().importBackup();
    if (!mounted) {
      return;
    }
    setState(() => _backupBusy = false);

    if (result == null) {
      return;
    }
    if (!result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось восстановить бэкап')),
      );
      return;
    }

    context.read<ThemeCubit>().refresh();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Данные восстановлены')),
    );

    final challenge = context.read<SettingsCubit>().state.challenge;
    if (challenge == null) {
      context.go('/setup');
    } else {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listenWhen: (prev, next) => prev.settings != next.settings,
        listener: (context, state) {
          context.read<ThemeCubit>().refresh();
        },
        builder: (context, state) {
          final cubit = context.read<SettingsCubit>();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              if (state.challenge != null) ...[
                const SettingsGroupHeader('Челлендж'),
                SettingsChallengeSection(
                  challenge: state.challenge!,
                  onSave: ({
                    required name,
                    required targetCount,
                    required startDate,
                    required endDate,
                  }) async {
                    await cubit.updateChallenge(
                      name: name,
                      targetCount: targetCount,
                      startDate: startDate,
                      endDate: endDate,
                    );
                  },
                  onStartNew: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Новый челлендж'),
                        content: const Text(
                          'Текущий челлендж будет завершён. Продолжить?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            child: const Text('Отмена'),
                          ),
                          FilledButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, true),
                            child: const Text('Начать новый'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true && context.mounted) {
                      await cubit.startNewChallenge();
                      if (context.mounted) {
                        context.go('/setup');
                      }
                    }
                  },
                ),
                const SizedBox(height: 12),
                SettingsFieldsSection(
                  fieldDefs: state.challenge!.fieldDefs,
                  onAdd: (label, type) => cubit.addField(
                    label: label,
                    type: type,
                  ),
                  onDelete: cubit.deleteField,
                ),
                const SizedBox(height: 8),
              ],
              const SettingsGroupHeader('Приложение'),
              SettingsAppearanceSection(
                themeMode: state.settings.themeMode,
                accentIndex: state.settings.accentColorIndex,
                vibrationEnabled: state.settings.vibrationEnabled,
                onThemeChanged: cubit.setThemeMode,
                onAccentSelected: cubit.setAccentColorIndex,
                onVibrationChanged: cubit.setVibration,
              ),
              const SizedBox(height: 12),
              SettingsNotificationsSection(
                enabled: state.settings.notificationsEnabled,
                slot: state.settings.notificationSlot,
                onEnabledChanged: cubit.setNotificationsEnabled,
                onSlotChanged: cubit.setNotificationSlot,
              ),
              const SizedBox(height: 12),
              SettingsWidgetsSection(
                onAddWidget: cubit.pinWidget,
              ),
              const SizedBox(height: 8),
              const SettingsGroupHeader('Данные'),
              SettingsBackupSection(
                busy: _backupBusy,
                onBackup: _onBackup,
                onRestore: _onRestore,
              ),
            ],
          );
        },
      ),
    );
  }
}
