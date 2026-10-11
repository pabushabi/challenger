import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kinochallenge/app/di/injection.dart';
import 'package:kinochallenge/app/router/app_router.dart';
import 'package:kinochallenge/core/theme/app_theme.dart';
import 'package:kinochallenge/features/settings/presentation/cubit/theme_cubit.dart';

class ChallengerApp extends StatefulWidget {
  const ChallengerApp({super.key});

  @override
  State<ChallengerApp> createState() => _ChallengerAppState();
}

class _ChallengerAppState extends State<ChallengerApp> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(challengeRepository: getIt());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: 'CHALLENGER',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(themeState.seedColor),
            darkTheme: AppTheme.dark(themeState.seedColor),
            themeMode: themeState.themeMode,
            locale: const Locale('ru'),
            supportedLocales: const [Locale('ru')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: _appRouter.router,
          );
        },
      ),
    );
  }
}
