import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class AppLogger {
  static void info(String message, {String name = 'App'}) {
    developer.log(message, name: name);
  }

  static void warning(String message, {String name = 'App', Object? error}) {
    developer.log(message, name: name, error: error, level: 900);
  }

  static void error(
    String message, {
    String name = 'App',
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: name,
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }

  static void debug(String message, {String name = 'App'}) {
    if (!kReleaseMode) {
      developer.log(message, name: name);
    }
  }
}
