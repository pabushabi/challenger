part of 'theme_cubit.dart';

@freezed
sealed class ThemeState with _$ThemeState {
  const factory ThemeState({
    @Default(CubitState.success) CubitState status,
    required ThemeMode themeMode,
    required int accentColorIndex,
    String? errorMessage,
  }) = _ThemeState;

  const ThemeState._();

  factory ThemeState.fromSettings(AppSettings settings) => ThemeState(
        themeMode: settings.themeMode,
        accentColorIndex: settings.accentColorIndex,
      );

  Color get seedColor => AppColors.accentByIndex(accentColorIndex);
}
