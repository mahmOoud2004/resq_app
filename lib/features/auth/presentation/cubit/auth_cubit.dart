import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/token_storage.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;
  final TokenStorage tokenStorage = TokenStorage();

  AuthCubit(this.repository) : super(AuthInitial());

  Future<void> login({
    required String phone,
    required String idNumber,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      /// تسجيل الدخول
      await repository.login(
        phone: phone,
        idNumber: idNumber,
        password: password,
      );

      /// نقرأ التوكن بعد الحفظ
      final token = await tokenStorage.getToken();

      ///  لو فيه token → دخول مباشر
      if (token != null && token.isNotEmpty) {
        emit(AuthSuccess());
      }
      ///  لو مفيش token → محتاج OTP
      else {
        emit(AuthNeedsOtp(phone));
      }
    } catch (e) {
      print("🔥 LOGIN ERROR: $e");
      emit(AuthError(e.toString()));
    }
  }

  Future<void> forgotPassword(String email) async {
    emit(AuthLoading());

    try {
      await repository.forgotPassword(email);

      emit(AuthNeedsOtp(email));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
