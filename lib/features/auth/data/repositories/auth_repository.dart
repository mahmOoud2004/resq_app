import '../../../../core/storage/token_storage.dart';
import '../datasource/auth_remote_datasource.dart';

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

    final token = result.token?.trim();
    if (token != null && token.isNotEmpty) {
      await storage.saveToken(token);
    } else {
      await storage.clear();
    }
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
