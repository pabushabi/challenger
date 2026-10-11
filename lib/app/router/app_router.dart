import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kinochallenge/app/di/injection.dart';
import 'package:kinochallenge/features/challenge/domain/repositories/challenge_repository.dart';
import 'package:kinochallenge/features/home/presentation/cubit/home_cubit.dart';
import 'package:kinochallenge/features/home/presentation/pages/home_page.dart';
import 'package:kinochallenge/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:kinochallenge/features/settings/presentation/pages/settings_page.dart';
import 'package:kinochallenge/features/setup/presentation/cubit/setup_cubit.dart';
import 'package:kinochallenge/features/setup/presentation/pages/setup_page.dart';

class AppRouter {
  AppRouter({required this.challengeRepository});

  final ChallengeRepository challengeRepository;

  late final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final challenge = await challengeRepository.getActiveChallenge();
      final loggingIn = state.matchedLocation == '/setup';

      if (challenge == null && !loggingIn) {
        return '/setup';
      }
      if (challenge != null && loggingIn) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/setup',
        name: 'setup',
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<SetupCubit>(),
            child: const SetupPage(),
          );
        },
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<HomeCubit>()..start(),
            child: const HomePage(),
          );
        },
        routes: [
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) {
              return BlocProvider(
                create: (_) => getIt<SettingsCubit>()..load(),
                child: const SettingsPage(),
              );
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Страница не найдена: ${state.error}'),
      ),
    ),
  );
}
