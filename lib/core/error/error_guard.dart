import 'dart:async';

import 'package:flutter/widgets.dart';

import 'app_exception.dart';
import 'app_logger.dart';
import 'error_handler.dart';

class ErrorGuard {
  static Future<T?> run<T>(
    Future<T> Function() action, {
    required String logName,
    String fallbackMessage = 'Something went wrong. Please try again.',
    void Function(AppException exception)? onError,
  }) async {
    try {
      return await action();
    } catch (error, stackTrace) {
      final exception = ErrorHandler.handle(
        error,
        stackTrace: stackTrace,
        fallbackMessage: fallbackMessage,
      );

      AppLogger.error(
        exception.developerMessage,
        name: logName,
        error: error,
        stackTrace: stackTrace,
      );

      onError?.call(exception);
      return null;
    }
  }
}

class AppErrorView extends StatelessWidget {
  final String message;

  const AppErrorView({
    super.key,
    this.message = 'Something went wrong. Please restart the app.',
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            message,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
