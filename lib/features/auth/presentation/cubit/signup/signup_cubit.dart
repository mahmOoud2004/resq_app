import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/core/error/app_logger.dart';
import 'package:resq_app/core/error/error_handler.dart';
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
      final formData = FormData.fromMap({
        "first_name": firstName.trim(),
        "last_name": lastName.trim(),
        "email": email.trim(),
        "phone": phone.trim(),
        "id_number": idNumber.trim(),
        "password": password,
        "password_confirmation": password,
        "role": role.trim(),
        "personal_id_image": await MultipartFile.fromFile(
          idImage.path,
          filename: "id.jpg",
        ),
      });

      await dio.post(ApiConstants.register, data: formData);
      emit(SignupSuccess());
    } catch (error, stackTrace) {
      final appException = ErrorHandler.handle(error, stackTrace: stackTrace);
      AppLogger.error(
        'Registration failed.',
        name: 'SignupCubit',
        error: error,
        stackTrace: stackTrace,
      );
      emit(SignupError(appException.userMessage));
    }
  }
}
