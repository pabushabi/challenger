import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:kinochallenge/features/challenge/data/database/app_database.dart';
import 'package:kinochallenge/features/challenge/data/repositories/challenge_repository_impl.dart';
import 'package:kinochallenge/features/challenge/domain/repositories/challenge_repository.dart';
import 'package:kinochallenge/features/home/presentation/cubit/home_cubit.dart';
import 'package:kinochallenge/features/home_widgets/data/home_widget_updater.dart';
import 'package:kinochallenge/features/notifications/data/notification_scheduler.dart';
import 'package:kinochallenge/features/settings/data/settings_repository.dart';
import 'package:kinochallenge/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:kinochallenge/features/settings/presentation/cubit/theme_cubit.dart';
import 'package:kinochallenge/features/setup/presentation/cubit/setup_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  getIt
    ..registerSingleton<SharedPreferences>(prefs)
    ..registerSingleton<AppDatabase>(AppDatabase())
    ..registerSingleton<SettingsRepository>(SettingsRepository(prefs))
    ..registerSingleton<ChallengeRepository>(
      ChallengeRepositoryImpl(getIt<AppDatabase>()),
    )
    ..registerSingleton<FlutterLocalNotificationsPlugin>(notificationsPlugin)
    ..registerSingleton<NotificationScheduler>(
      NotificationScheduler(notificationsPlugin),
    )
    ..registerSingleton<HomeWidgetUpdater>(HomeWidgetUpdater())
    ..registerLazySingleton<ThemeCubit>(
      () => ThemeCubit(getIt<SettingsRepository>()),
    )
    ..registerFactory<SetupCubit>(
      () => SetupCubit(
        challengeRepository: getIt(),
        homeWidgetUpdater: getIt(),
        notificationScheduler: getIt(),
        settingsRepository: getIt(),
      ),
    )
    ..registerFactory<HomeCubit>(
      () => HomeCubit(
        challengeRepository: getIt(),
        settingsRepository: getIt(),
        notificationScheduler: getIt(),
        homeWidgetUpdater: getIt(),
      ),
    )
    ..registerFactory<SettingsCubit>(
      () => SettingsCubit(
        settingsRepository: getIt(),
        challengeRepository: getIt(),
        notificationScheduler: getIt(),
        homeWidgetUpdater: getIt(),
      ),
    );

  await getIt<NotificationScheduler>().initialize();
  await getIt<HomeWidgetUpdater>().initialize();
}
