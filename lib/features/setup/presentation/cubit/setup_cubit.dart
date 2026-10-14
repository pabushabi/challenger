import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kinochallenge/core/constants/cubit_state.dart';
import 'package:kinochallenge/features/challenge/domain/repositories/challenge_repository.dart';
import 'package:kinochallenge/features/home_widgets/data/home_widget_updater.dart';
import 'package:kinochallenge/features/notifications/data/notification_scheduler.dart';
import 'package:kinochallenge/features/settings/data/backup_service.dart';
import 'package:kinochallenge/features/settings/data/settings_repository.dart';

part 'setup_cubit.freezed.dart';
part 'setup_state.dart';

class SetupCubit extends Cubit<SetupState> {
  SetupCubit({
    required ChallengeRepository challengeRepository,
    required HomeWidgetUpdater homeWidgetUpdater,
    required NotificationScheduler notificationScheduler,
    required SettingsRepository settingsRepository,
    required BackupService backupService,
  })  : _challengeRepository = challengeRepository,
        _homeWidgetUpdater = homeWidgetUpdater,
        _notificationScheduler = notificationScheduler,
        _settingsRepository = settingsRepository,
        _backupService = backupService,
        super(SetupState.initial());

  final ChallengeRepository _challengeRepository;
  final HomeWidgetUpdater _homeWidgetUpdater;
  final NotificationScheduler _notificationScheduler;
  final SettingsRepository _settingsRepository;
  final BackupService _backupService;

  void updateName(String value) {
    emit(state.copyWith(name: value, errorMessage: null));
  }

  void updateTargetCount(String value) {
    emit(state.copyWith(targetCountText: value, errorMessage: null));
  }

  void updateStartDate(DateTime value) {
    emit(state.copyWith(startDate: value, errorMessage: null));
  }

  void updateEndDate(DateTime value) {
    emit(state.copyWith(endDate: value, errorMessage: null));
  }

  Future<bool> submit() async {
    final name = state.name.trim();
    final target = int.tryParse(state.targetCountText.trim());

    if (name.isEmpty) {
      emit(state.copyWith(errorMessage: 'Введите название челленджа'));
      return false;
    }
    if (target == null || target <= 0) {
      emit(state.copyWith(errorMessage: 'Укажите положительное число событий'));
      return false;
    }
    if (!state.endDate.isAfter(state.startDate) &&
        !_isSameDay(state.endDate, state.startDate)) {
      emit(state.copyWith(errorMessage: 'Дата окончания должна быть позже начала'));
      return false;
    }

    emit(state.copyWith(status: CubitState.loading, errorMessage: null));
    try {
      final challenge = await _challengeRepository.createChallenge(
        name: name,
        targetCount: target,
        startDate: state.startDate,
        endDate: state.endDate,
      );
      await _homeWidgetUpdater.update(challenge);
      await _notificationScheduler.reschedule(
        settings: _settingsRepository.load(),
        challenge: challenge,
      );
      emit(state.copyWith(status: CubitState.success));
      return true;
    } catch (_) {
      emit(
        state.copyWith(
          status: CubitState.error,
          errorMessage: 'Не удалось создать челлендж',
        ),
      );
      return false;
    }
  }

  /// `null` — пользователь отменил выбор файла.
  Future<bool?> restoreFromBackup() async {
    try {
      final payload = await _backupService.pickBackup();
      if (payload == null) {
        return null;
      }
      if (payload.challenge == null) {
        emit(
          state.copyWith(
            errorMessage: 'В бэкапе нет челленджа',
          ),
        );
        return false;
      }

      emit(state.copyWith(status: CubitState.loading, errorMessage: null));
      await _backupService.applyBackup(payload);
      final challenge = await _challengeRepository.getActiveChallenge();
      final settings = _settingsRepository.load();
      await _homeWidgetUpdater.update(challenge);
      await _notificationScheduler.reschedule(
        settings: settings,
        challenge: challenge,
      );
      emit(state.copyWith(status: CubitState.success));
      return true;
    } catch (_) {
      emit(
        state.copyWith(
          status: CubitState.error,
          errorMessage: 'Не удалось восстановить бэкап',
        ),
      );
      return false;
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
