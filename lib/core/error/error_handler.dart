import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import 'app_exception.dart';

class ErrorHandler {
  static AppException handle(
    Object error, {
    StackTrace? stackTrace,
    String fallbackMessage = 'Something went wrong. Please try again.',
  }) {
    if (error is AppException) {
      return error;
    }

    if (error is DioException) {
      return _handleDio(error);
    }

    if (error is SocketException) {
      return AppException(
        code: 'network_offline',
        userMessage: 'No internet connection. Please check your network.',
        developerMessage: error.message,
        originalError: error,
      );
    }

    if (error is TimeoutException) {
      return AppException(
        code: 'request_timeout',
        userMessage: 'The request took too long. Please try again.',
        developerMessage: error.message ?? 'Timeout',
        originalError: error,
      );
    }

    if (error is FormatException) {
      return AppException(
        code: 'parse_error',
        userMessage: 'We could not process the server response.',
        developerMessage: error.message,
        originalError: error,
      );
    }

    if (error is PlatformException) {
      return AppException(
        code: error.code,
        userMessage: _platformMessage(error),
        developerMessage: error.message ?? error.code,
        originalError: error,
      );
    }

    if (error is PermissionDeniedException) {
      return const AppException(
        code: 'location_permission_denied',
        userMessage: 'Location permission is required to continue.',
        developerMessage: 'Geolocator permission denied.',
      );
    }

    return AppException(
      code: 'unknown_error',
      userMessage: fallbackMessage,
      developerMessage: error.toString(),
      originalError: error,
    );
  }

  static AppException _handleDio(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;
    final message = _extractApiMessage(responseData);

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return AppException(
          code: 'request_timeout',
          userMessage: 'The server is taking too long to respond. Please try again.',
          developerMessage: 'Request timeout: ${error.requestOptions.uri}',
          originalError: error,
        );
      case DioExceptionType.badCertificate:
      case DioExceptionType.connectionError:
        return AppException(
          code: 'network_error',
          userMessage: 'No internet connection. Please check your network.',
          developerMessage: error.message ?? 'Connection error',
          originalError: error,
        );
      case DioExceptionType.cancel:
        return AppException(
          code: 'request_cancelled',
          userMessage: 'The request was cancelled.',
          developerMessage: error.message ?? 'Cancelled',
          originalError: error,
        );
      case DioExceptionType.badResponse:
        if (statusCode == 401) {
          return AppException(
            code: 'unauthorized',
            userMessage: 'Your session expired. Please sign in again.',
            developerMessage: 'Unauthorized request.',
            originalError: error,
          );
        }

        if (statusCode == 403) {
          return AppException(
            code: 'forbidden',
            userMessage: message ?? 'You do not have permission to do this action.',
            developerMessage: 'Forbidden request.',
            originalError: error,
          );
        }

        if (statusCode == 404) {
          return AppException(
            code: 'not_found',
            userMessage: message ?? 'The requested resource was not found.',
            developerMessage: 'Resource not found.',
            originalError: error,
          );
        }

        if (statusCode == 422) {
          return AppException(
            code: 'validation_error',
            userMessage: message ?? 'Please review your input and try again.',
            developerMessage: 'Validation failed.',
            originalError: error,
          );
        }

        if (statusCode != null && statusCode >= 500) {
          return AppException(
            code: 'server_error',
            userMessage: 'Server is temporarily unavailable. Please try again.',
            developerMessage: 'Server error $statusCode.',
            originalError: error,
          );
        }

        return AppException(
          code: 'api_error',
          userMessage: message ?? 'Something went wrong. Please try again.',
          developerMessage: 'Unexpected API response $statusCode.',
          originalError: error,
        );
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return AppException(
            code: 'network_offline',
            userMessage: 'No internet connection. Please check your network.',
            developerMessage: error.error.toString(),
            originalError: error,
          );
        }
        return AppException(
          code: 'dio_unknown',
          userMessage: message ?? 'Something went wrong. Please try again.',
          developerMessage: error.message ?? 'Unknown Dio error',
          originalError: error,
        );
    }
  }

  static String? _extractApiMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }

      final errors = data['errors'];
      if (errors is Map<String, dynamic>) {
        for (final entry in errors.values) {
          if (entry is List && entry.isNotEmpty && entry.first is String) {
            return entry.first as String;
          }
          if (entry is String && entry.trim().isNotEmpty) {
            return entry.trim();
          }
        }
      }
    }

    return null;
  }

  static String _platformMessage(PlatformException error) {
    switch (error.code) {
      case 'network_error':
        return 'No internet connection. Please check your network.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
