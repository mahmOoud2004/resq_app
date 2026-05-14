import 'package:dio/dio.dart';
import 'package:resq_app/core/error/app_logger.dart';
import 'package:resq_app/core/error/error_handler.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/login_response_model.dart';

class AuthRemoteDataSource {
  final Dio dio = DioClient().dio;

  Future<LoginResponseModel> login({
    required String phone,
    required String idNumber,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.login,
        data: {
          "phone": phone.trim(),
          "id_number": idNumber.trim(),
          "password": password,
        },
      );

      if (response.data is! Map<String, dynamic>) {
        throw const FormatException('Login response is invalid.');
      }

      return LoginResponseModel.fromJson(response.data as Map<String, dynamic>);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Login request failed.',
        name: 'AuthRemoteDataSource',
        error: error,
        stackTrace: stackTrace,
      );
      throw ErrorHandler.handle(error, stackTrace: stackTrace);
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await dio.post(
        ApiConstants.forgotPassword,
        data: {"email": email.trim()},
      );
    } catch (error, stackTrace) {
      AppLogger.error(
        'Forgot password request failed.',
        name: 'AuthRemoteDataSource',
        error: error,
        stackTrace: stackTrace,
      );
      throw ErrorHandler.handle(error, stackTrace: stackTrace);
    }
  }

  Future<void> resetPassword({
    required String email,
    required String password,
    required String otp,
  }) async {
    try {
      await dio.post(
        ApiConstants.resetPassword,
        data: {
          "email": email.trim(),
          "otp": otp.trim(),
          "password": password,
          "password_confirmation": password,
        },
      );
    } catch (error, stackTrace) {
      AppLogger.error(
        'Reset password request failed.',
        name: 'AuthRemoteDataSource',
        error: error,
        stackTrace: stackTrace,
      );
      throw ErrorHandler.handle(error, stackTrace: stackTrace);
    }
  }
}
