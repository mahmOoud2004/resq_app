import 'dart:io';

import 'package:dio/dio.dart';
import 'package:resq_app/core/error/app_logger.dart';
import 'package:resq_app/core/error/error_handler.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getProfile();

  Future<void> updateProfile({
    required String phone,
    required String password,
    required String confirmPassword,
    File? image,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio = DioClient().dio;

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await dio.get(ApiConstants.profile);
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const FormatException('Profile response is invalid.');
      }

      final userJson = data["user"];
      if (userJson is! Map<String, dynamic>) {
        throw const FormatException('Profile payload is invalid.');
      }

      return UserModel.fromJson(userJson);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Get profile failed.',
        name: 'ProfileRemoteDataSource',
        error: error,
        stackTrace: stackTrace,
      );
      throw ErrorHandler.handle(error, stackTrace: stackTrace);
    }
  }

  @override
  Future<void> updateProfile({
    required String phone,
    required String password,
    required String confirmPassword,
    File? image,
  }) async {
    try {
      final data = FormData.fromMap({
        "phone": phone.trim(),
        "password": password,
        "password_confirmation": confirmPassword,
        if (image != null) "image": await MultipartFile.fromFile(image.path),
      });

      await dio.post(ApiConstants.updateUser, data: data);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Update profile failed.',
        name: 'ProfileRemoteDataSource',
        error: error,
        stackTrace: stackTrace,
      );
      throw ErrorHandler.handle(error, stackTrace: stackTrace);
    }
  }
}
