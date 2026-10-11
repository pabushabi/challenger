part of 'setup_cubit.dart';

@freezed
sealed class SetupState with _$SetupState {
  const factory SetupState({
    @Default(CubitState.initial) CubitState status,
    @Default('') String name,
    @Default('100') String targetCountText,
    required DateTime startDate,
    required DateTime endDate,
    String? errorMessage,
  }) = _SetupState;

  const SetupState._();

  factory SetupState.initial() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = DateTime(now.year + 1, now.month, now.day);
    return SetupState(startDate: start, endDate: end);
  }
}
