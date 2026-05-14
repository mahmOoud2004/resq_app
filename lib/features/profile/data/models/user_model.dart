import 'package:resq_app/core/network/api_constants.dart';

class UserModel {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String nationalId;

  final String role; // ⭐ الجديد

  final String? profileImage;
  final String? idCardImage;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.nationalId,
    required this.role, // ⭐
    this.profileImage,
    this.idCardImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final profilePath = json["image"];
    final idCardPath = json["personal_id_image"];

    return UserModel(
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      phone: json["phone"] ?? "",
      email: json["email"] ?? "",
      nationalId: json["id_number"] ?? "",
      role: json["role"] ?? "user", // ⭐

      profileImage: profilePath,
      idCardImage: idCardPath != null
          ? "${ApiConstants.storageBaseUrl}$idCardPath"
          : null,
    );
  }

  String get fullName => "$firstName $lastName";
}
