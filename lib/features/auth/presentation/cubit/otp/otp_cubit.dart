import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/core/error/app_logger.dart';
import 'package:resq_app/core/error/error_handler.dart';
import 'package:resq_app/core/network/api_constants.dart';
import 'package:resq_app/core/network/dio_client.dart';

import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpInitial());

  final Dio dio = DioClient().dio;

  Future<void> verifySignupOtp({
    required String email,
    required String otp,
  }) async {
    emit(OtpLoading());

    try {
      await dio.post(
        ApiConstants.verifyOtp,
        data: {"email": email.trim(), "otp": otp.trim()},
      );

      emit(OtpSuccess());
    } catch (error, stackTrace) {
      final appException = ErrorHandler.handle(error, stackTrace: stackTrace);
      AppLogger.error(
        'OTP verification failed.',
        name: 'OtpCubit',
        error: error,
        stackTrace: stackTrace,
      );
      emit(OtpError(appException.userMessage));
    }
  }

  Future<void> verifyResetOtp({
    required String email,
    required String otp,
  }) async {
    if (email.trim().isNotEmpty && otp.trim().length == 4) {
      emit(OtpSuccess());
    } else {
      emit(OtpError("Invalid OTP"));
    }
  }
}
