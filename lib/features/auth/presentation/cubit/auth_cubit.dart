import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/core/error/app_logger.dart';
import 'package:resq_app/core/error/error_handler.dart';

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
      await repository.login(
        phone: phone,
        idNumber: idNumber,
        password: password,
      );

      final token = await tokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        emit(AuthSuccess());
      } else {
        emit(AuthNeedsOtp(phone));
      }
    } catch (error, stackTrace) {
      final appException = ErrorHandler.handle(error, stackTrace: stackTrace);
      AppLogger.error(
        'Login flow failed.',
        name: 'AuthCubit',
        error: error,
        stackTrace: stackTrace,
      );
      emit(AuthError(appException.userMessage));
    }
  }

  Future<void> forgotPassword(String email) async {
    emit(AuthLoading());

    try {
      await repository.forgotPassword(email);
      emit(AuthNeedsOtp(email));
    } catch (error, stackTrace) {
      final appException = ErrorHandler.handle(error, stackTrace: stackTrace);
      AppLogger.error(
        'Forgot password flow failed.',
        name: 'AuthCubit',
        error: error,
        stackTrace: stackTrace,
      );
      emit(AuthError(appException.userMessage));
    }
  }
}
