import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kinochallenge/core/constants/cubit_state.dart';
import 'package:kinochallenge/features/challenge/domain/entities/challenge.dart';
import 'package:kinochallenge/features/challenge/domain/entities/field_type.dart';
import 'package:kinochallenge/features/challenge/domain/repositories/challenge_repository.dart';
import 'package:kinochallenge/features/home_widgets/data/home_widget_updater.dart';
import 'package:kinochallenge/features/notifications/data/notification_scheduler.dart';
import 'package:kinochallenge/features/settings/data/settings_repository.dart';
import 'package:kinochallenge/features/settings/domain/entities/app_settings.dart';

part 'settings_cubit.freezed.dart';
part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required SettingsRepository settingsRepository,
    required ChallengeRepository challengeRepository,
    required NotificationScheduler notificationScheduler,
    required HomeWidgetUpdater homeWidgetUpdater,
  })  : _settingsRepository = settingsRepository,
        _challengeRepository = challengeRepository,
        _notificationScheduler = notificationScheduler,
        _homeWidgetUpdater = homeWidgetUpdater,
        super(SettingsState.initial());

  final SettingsRepository _settingsRepository;
  final ChallengeRepository _challengeRepository;
  final NotificationScheduler _notificationScheduler;
  final HomeWidgetUpdater _homeWidgetUpdater;

  Future<void> load() async {
    emit(state.copyWith(status: CubitState.loading));
    try {
      final settings = _settingsRepository.load();
      final challenge = await _challengeRepository.getActiveChallenge();
      emit(
        state.copyWith(
          status: CubitState.success,
          settings: settings,
          challenge: challenge,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CubitState.error,
          errorMessage: 'Не удалось загрузить настройки',
        ),
      );
    }
  }

  Future<void> setVibration(bool enabled) async {
    final next = state.settings.copyWith(vibrationEnabled: enabled);
    await _persist(next);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final next = state.settings.copyWith(themeMode: mode);
    await _persist(next);
  }

  Future<void> setAccentColorIndex(int index) async {
    final next = state.settings.copyWith(accentColorIndex: index);
    await _persist(next);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final next = state.settings.copyWith(notificationsEnabled: enabled);
    await _persist(next);
    await _notificationScheduler.reschedule(
      settings: next,
      challenge: state.challenge,
    );
  }

  Future<void> setNotificationSlot(NotificationSlot slot) async {
    final next = state.settings.copyWith(notificationSlot: slot);
    await _persist(next);
    await _notificationScheduler.reschedule(
      settings: next,
      challenge: state.challenge,
    );
  }

  Future<void> updateChallenge({
    required String name,
    required int targetCount,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final challenge = state.challenge;
    if (challenge == null) {
      return;
    }
    try {
      await _challengeRepository.updateChallenge(
        id: challenge.id,
        name: name,
        targetCount: targetCount,
        startDate: startDate,
        endDate: endDate,
      );
      final updated = await _challengeRepository.getActiveChallenge();
      emit(state.copyWith(challenge: updated));
      await _homeWidgetUpdater.update(updated);
      await _notificationScheduler.reschedule(
        settings: state.settings,
        challenge: updated,
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: CubitState.error,
          errorMessage: 'Не удалось обновить челлендж',
        ),
      );
    }
  }

  Future<void> addField({
    required String label,
    required FieldType type,
  }) async {
    final challenge = state.challenge;
    if (challenge == null) {
      return;
    }
    await _challengeRepository.addFieldDef(
      challengeId: challenge.id,
      label: label,
      type: type,
    );
    final updated = await _challengeRepository.getActiveChallenge();
    emit(state.copyWith(challenge: updated));
  }

  Future<void> deleteField(String fieldId) async {
    await _challengeRepository.deleteFieldDef(fieldId);
    final updated = await _challengeRepository.getActiveChallenge();
    emit(state.copyWith(challenge: updated));
  }

  Future<void> startNewChallenge() async {
    final challenge = state.challenge;
    if (challenge == null) {
      return;
    }
    await _challengeRepository.deactivateChallenge(challenge.id);
    emit(state.copyWith(challenge: null));
    await _homeWidgetUpdater.update(null);
    await _notificationScheduler.reschedule(
      settings: state.settings,
      challenge: null,
    );
  }

  Future<void> pinWidget() async {
    await _homeWidgetUpdater.requestPin();
  }

  Future<void> _persist(AppSettings settings) async {
    await _settingsRepository.save(settings);
    emit(state.copyWith(settings: settings, status: CubitState.success));
  }
}
