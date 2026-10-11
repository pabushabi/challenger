import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kinochallenge/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:kinochallenge/features/settings/presentation/cubit/theme_cubit.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/settings_accent_section.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/settings_challenge_section.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/settings_fields_section.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/settings_notifications_section.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/settings_theme_section.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/settings_vibration_tile.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/settings_widgets_section.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            children: [
              SettingsVibrationTile(
                enabled: state.settings.vibrationEnabled,
                onChanged: context.read<SettingsCubit>().setVibration,
              ),
              const SizedBox(height: 12),
              SettingsThemeSection(
                themeMode: state.settings.themeMode,
                onChanged: context.read<SettingsCubit>().setThemeMode,
              ),
              const SizedBox(height: 12),
              SettingsAccentSection(
                selectedIndex: state.settings.accentColorIndex,
                onSelected: context.read<SettingsCubit>().setAccentColorIndex,
              ),
              const SizedBox(height: 12),
              SettingsWidgetsSection(
                onAddWidget: context.read<SettingsCubit>().pinWidget,
              ),
              if (state.challenge != null) ...[
                const SizedBox(height: 12),
                SettingsChallengeSection(
                  challenge: state.challenge!,
                  onSave: ({
                    required name,
                    required targetCount,
                    required startDate,
                    required endDate,
                  }) async {
                    await context.read<SettingsCubit>().updateChallenge(
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
                      await context.read<SettingsCubit>().startNewChallenge();
                      if (context.mounted) {
                        context.go('/setup');
                      }
                    }
                  },
                ),
                const SizedBox(height: 12),
                SettingsFieldsSection(
                  fieldDefs: state.challenge!.fieldDefs,
                  onAdd: (label, type) =>
                      context.read<SettingsCubit>().addField(
                            label: label,
                            type: type,
                          ),
                  onDelete: context.read<SettingsCubit>().deleteField,
                ),
              ],
              const SizedBox(height: 12),
              SettingsNotificationsSection(
                enabled: state.settings.notificationsEnabled,
                slot: state.settings.notificationSlot,
                onEnabledChanged:
                    context.read<SettingsCubit>().setNotificationsEnabled,
                onSlotChanged:
                    context.read<SettingsCubit>().setNotificationSlot,
              ),
            ],
          );
        },
      ),
    );
  }
}
