part of 'home_cubit.dart';

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState({
    @Default(CubitState.initial) CubitState status,
    Challenge? challenge,
    ChallengeStats? stats,
    String? errorMessage,
  }) = _HomeState;

  const HomeState._();

  factory HomeState.initial() => const HomeState();
}
