import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:resq_app/core/network/api_constants.dart';
import 'package:resq_app/core/network/dio_client.dart';
import 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  final Dio dio = DioClient().dio;

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String idNumber,
    required String password,
    required File idImage,
    required String role,
  }) async {
    emit(SignupLoading());

    try {
      FormData formData = FormData.fromMap({
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "id_number": idNumber,
        "password": password,
        "password_confirmation": password,
        "role": role,
        "personal_id_image": await MultipartFile.fromFile(
          idImage.path,
          filename: "id.jpg",
        ),
      });

      final response = await dio.post(ApiConstants.register, data: formData);

      print("REGISTER RESPONSE: ${response.data}");

      emit(SignupSuccess());
    } catch (e) {
      print("REGISTER ERROR: $e");
      emit(SignupError(e.toString()));
    }
  }
}
