import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:resq_app/core/network/api_constants.dart';
import 'package:resq_app/core/network/dio_client.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpInitial());

  final Dio dio = DioClient().dio;

  Future<void> verifyOtp({required String email, required String otp}) async {
    emit(OtpLoading());

    try {
      final response = await dio.post(
        ApiConstants.verifyOtp,
        data: {"email": email, "otp": otp},
      );

      print("OTP RESPONSE: ${response.data}");

      emit(OtpSuccess());
    } catch (e) {
      print("OTP ERROR: $e");
      emit(OtpError("Invalid OTP"));
    }
  }
}
