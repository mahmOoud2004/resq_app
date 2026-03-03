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
}
