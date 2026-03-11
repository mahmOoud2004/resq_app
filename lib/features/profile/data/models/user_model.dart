class UserModel {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String nationalId;

  final String? profileImage;
  final String? idCardImage;

  static const String _baseImageUrl =
      "https://feelinglessly-preocular-xochitl.ngrok-free.dev/storage/";

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.nationalId,
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

      profileImage: profilePath,
      idCardImage: idCardPath != null ? "$_baseImageUrl$idCardPath" : null,
    );
  }

  String get fullName => "$firstName $lastName";
}
