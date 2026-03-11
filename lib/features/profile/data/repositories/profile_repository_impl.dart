import 'dart:io';

import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/user_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserModel> getProfile() async {
    return await remoteDataSource.getProfile();
  }

  @override
  Future<void> updateProfile({
    required String phone,
    required String password,
    required String confirmPassword,
    File? image,
  }) {
    return remoteDataSource.updateProfile(
      phone: phone,
      password: password,
      confirmPassword: confirmPassword,
      image: image,
    );
  }
}
