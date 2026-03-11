import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_constants.dart';
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
    final response = await dio.get(ApiConstants.profile);

    final userJson = response.data["user"];

    return UserModel.fromJson(userJson);
  }

  @override
  Future<void> updateProfile({
    required String phone,
    required String password,
    required String confirmPassword,
    File? image,
  }) async {
    FormData data = FormData.fromMap({
      "phone": phone,
      "password": password,
      "password_confirmation": confirmPassword,

      if (image != null) "image": await MultipartFile.fromFile(image.path),
    });

    await dio.post(
      ApiConstants.updateUser, // الأفضل استخدام constant
      data: data,
    );
  }
}
