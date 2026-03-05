import '../datasource/auth_remote_datasource.dart';
import '../../../../core/storage/token_storage.dart';

class AuthRepository {
  final AuthRemoteDataSource remote;
  final TokenStorage storage;

  AuthRepository(this.remote, this.storage);

  Future<void> login({
    required String phone,
    required String idNumber,
    required String password,
  }) async {
    final result = await remote.login(
      phone: phone,
      idNumber: idNumber,
      password: password,
    );

    await storage.saveToken(result.token?.toString() ?? '');
  }

  Future<void> forgotPassword(String email) async {
    await remote.forgotPassword(email);
  }

  Future<void> resetPassword({
    required String email,
    required String password,
    required String otp,
  }) async {
    await remote.resetPassword(email: email, password: password, otp: otp);
  }
}
