import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:resq_app/core/network/api_constants.dart';
import 'package:resq_app/core/network/dio_client.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpInitial());

  final Dio dio = DioClient().dio;

  /// OTP verification (signup)
  Future<void> verifySignupOtp({
    required String email,
    required String otp,
  }) async {
    emit(OtpLoading());

    try {
      final response = await dio.post(
        ApiConstants.verifyOtp,
        data: {"email": email, "otp": otp},
      );

      print("VERIFY SIGNUP OTP RESPONSE: ${response.data}");

      emit(OtpSuccess());
    } catch (e) {
      print("OTP SIGNUP ERROR: $e");
      emit(OtpError("Invalid OTP"));
    }
  }

  /// OTP verification (reset password)
  /// مفيش API هنا — بس بنتأكد إن OTP مكتوب
  Future<void> verifyResetOtp({
    required String email,
    required String otp,
  }) async {
    if (otp.length == 4) {
      emit(OtpSuccess());
    } else {
      emit(OtpError("Invalid OTP"));
    }
  }
}
