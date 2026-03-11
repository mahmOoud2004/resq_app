import 'dart:io';
import '../../data/models/user_model.dart';

abstract class ProfileRepository {
  Future<UserModel> getProfile();

  Future<void> updateProfile({
    required String phone,
    required String password,
    required String confirmPassword,
    File? image,
  });
}
