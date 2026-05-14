import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:resq_app/core/theme/app_theme.dart';
import 'package:resq_app/core/theme/theme_cubit.dart';
import 'package:resq_app/config/routers/app_router.dart';
import 'package:resq_app/core/constants/app_color.dart';
import 'package:resq_app/core/error/app_logger.dart';
import 'package:resq_app/core/error/error_guard.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.background,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    FlutterError.onError = (details) {
      AppLogger.error(
        details.exceptionAsString(),
        name: 'FlutterError',
        error: details.exception,
        stackTrace: details.stack,
      );
    };

    ErrorWidget.builder = (details) {
      AppLogger.error(
        details.exceptionAsString(),
        name: 'ErrorWidget',
        error: details.exception,
        stackTrace: details.stack,
      );

      return const Material(
        color: AppColors.background,
        child: AppErrorView(),
      );
    };

    await ErrorGuard.run(
      () => dotenv.load(fileName: ".env"),
      logName: 'Bootstrap',
      fallbackMessage: 'Failed to load application configuration.',
    );

    runApp(const MyApp());
  }, (error, stackTrace) {
    AppLogger.error(
      'Uncaught zone error',
      name: 'Bootstrap',
      error: error,
      stackTrace: stackTrace,
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'resQ App',
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
