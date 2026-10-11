part of 'settings_cubit.dart';

@freezed
sealed class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(CubitState.initial) CubitState status,
    Challenge? challenge,
    required AppSettings settings,
    String? errorMessage,
  }) = _SettingsState;

  const SettingsState._();

  factory SettingsState.initial() => SettingsState(
        settings: AppSettings.defaults(),
      );
}
