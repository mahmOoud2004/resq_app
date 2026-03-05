import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/login_response_model.dart';

class AuthRemoteDataSource {
  final Dio dio = DioClient().dio;

  Future<LoginResponseModel> login({
    required String phone,
    required String idNumber,
    required String password,
  }) async {
    final response = await dio.post(
      ApiConstants.login,
      data: {"phone": phone, "id_number": idNumber, "password": password},
    );

    print(response.data);

    return LoginResponseModel.fromJson(response.data);
  }

  Future<void> forgotPassword(String email) async {
    final response = await dio.post(
      ApiConstants.forgotPassword,
      data: {"email": email},
    );

    print("FORGOT PASSWORD RESPONSE: ${response.data}");
  }

  Future<void> resetPassword({
    required String email,
    required String password,
    required String otp,
  }) async {
    final response = await dio.post(
      ApiConstants.resetPassword,
      data: {
        "email": email,
        "otp": otp,
        "password": password,
        "password_confirmation": password,
      },
    );

    print("RESET PASSWORD RESPONSE: ${response.data}");
  }
}
