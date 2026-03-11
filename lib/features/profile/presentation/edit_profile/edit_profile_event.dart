import 'dart:io';

abstract class EditProfileEvent {}

class UpdateProfileEvent extends EditProfileEvent {
  final String phone;
  final String password;
  final String confirmPassword;
  final File? image;

  UpdateProfileEvent({
    required this.phone,
    required this.password,
    required this.confirmPassword,
    this.image,
  });
}
