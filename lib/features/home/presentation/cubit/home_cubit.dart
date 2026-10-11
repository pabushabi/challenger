import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kinochallenge/core/constants/cubit_state.dart';
import 'package:kinochallenge/core/utils/challenge_stats.dart';
import 'package:kinochallenge/features/challenge/domain/entities/challenge.dart';
import 'package:kinochallenge/features/challenge/domain/repositories/challenge_repository.dart';
import 'package:kinochallenge/features/home_widgets/data/home_widget_updater.dart';
import 'package:kinochallenge/features/notifications/data/notification_scheduler.dart';
import 'package:kinochallenge/features/settings/data/settings_repository.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required ChallengeRepository challengeRepository,
    required SettingsRepository settingsRepository,
    required NotificationScheduler notificationScheduler,
    required HomeWidgetUpdater homeWidgetUpdater,
  })  : _challengeRepository = challengeRepository,
        _settingsRepository = settingsRepository,
        _notificationScheduler = notificationScheduler,
        _homeWidgetUpdater = homeWidgetUpdater,
        super(HomeState.initial());

  final ChallengeRepository _challengeRepository;
  final SettingsRepository _settingsRepository;
  final NotificationScheduler _notificationScheduler;
  final HomeWidgetUpdater _homeWidgetUpdater;
  StreamSubscription<Challenge?>? _subscription;

  Future<void> start() async {
    emit(state.copyWith(status: CubitState.loading));
    await _subscription?.cancel();
    _subscription = _challengeRepository.watchActiveChallenge().listen(
      (challenge) async {
        if (challenge == null) {
          emit(
            state.copyWith(
              status: CubitState.success,
              challenge: null,
              stats: null,
            ),
          );
          return;
        }
        final stats = ChallengeStats(
          completed: challenge.completedCount,
          target: challenge.targetCount,
          startDate: challenge.startDate,
          endDate: challenge.endDate,
          now: DateTime.now(),
        );
        emit(
          state.copyWith(
            status: CubitState.success,
            challenge: challenge,
            stats: stats,
            errorMessage: null,
          ),
        );
        await _homeWidgetUpdater.update(challenge);
      },
      onError: (_) {
        emit(
          state.copyWith(
            status: CubitState.error,
            errorMessage: 'Не удалось загрузить челлендж',
          ),
        );
      },
    );
  }

  Future<void> addEvent(Map<String, String> fieldValues) async {
    final challenge = state.challenge;
    if (challenge == null) {
      return;
    }

    try {
      await _challengeRepository.addEvent(
        challengeId: challenge.id,
        fieldValues: fieldValues,
      );

      final settings = _settingsRepository.load();
      if (settings.vibrationEnabled) {
        await HapticFeedback.mediumImpact();
      }

      await _refreshAfterMutation();
      await _notificationScheduler.reschedule(
        settings: settings,
        challenge: state.challenge,
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: CubitState.error,
          errorMessage: 'Не удалось сохранить событие',
        ),
      );
    }
  }

  Future<void> updateEvent({
    required String eventId,
    required Map<String, String> fieldValues,
  }) async {
    try {
      await _challengeRepository.updateEvent(
        eventId: eventId,
        fieldValues: fieldValues,
      );

      final settings = _settingsRepository.load();
      if (settings.vibrationEnabled) {
        await HapticFeedback.selectionClick();
      }

      await _refreshAfterMutation();
      await _notificationScheduler.reschedule(
        settings: settings,
        challenge: state.challenge,
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: CubitState.error,
          errorMessage: 'Не удалось изменить событие',
        ),
      );
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _challengeRepository.deleteEvent(eventId);
      final settings = _settingsRepository.load();
      await _refreshAfterMutation();
      await _notificationScheduler.reschedule(
        settings: settings,
        challenge: state.challenge,
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: CubitState.error,
          errorMessage: 'Не удалось удалить событие',
        ),
      );
    }
  }

  Future<void> _refreshAfterMutation() async {
    final updated = await _challengeRepository.getActiveChallenge();
    if (updated == null) {
      emit(
        state.copyWith(
          status: CubitState.success,
          challenge: null,
          stats: null,
        ),
      );
      await _homeWidgetUpdater.update(null);
      return;
    }

    final stats = ChallengeStats(
      completed: updated.completedCount,
      target: updated.targetCount,
      startDate: updated.startDate,
      endDate: updated.endDate,
      now: DateTime.now(),
    );
    emit(
      state.copyWith(
        status: CubitState.success,
        challenge: updated,
        stats: stats,
        errorMessage: null,
      ),
    );
    await _homeWidgetUpdater.update(updated);
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
