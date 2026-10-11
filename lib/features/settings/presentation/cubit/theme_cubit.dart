import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kinochallenge/core/constants/cubit_state.dart';
import 'package:kinochallenge/core/theme/app_colors.dart';
import 'package:kinochallenge/features/settings/data/settings_repository.dart';
import 'package:kinochallenge/features/settings/domain/entities/app_settings.dart';

part 'theme_cubit.freezed.dart';
part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this._settingsRepository)
      : super(ThemeState.fromSettings(_settingsRepository.load()));

  final SettingsRepository _settingsRepository;

  void refresh() {
    emit(ThemeState.fromSettings(_settingsRepository.load()));
  }

  Future<void> apply(AppSettings settings) async {
    await _settingsRepository.save(settings);
    emit(ThemeState.fromSettings(settings));
  }
}
