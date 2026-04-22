class PendingUserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;

  final String? image;
  final String? idNumber;
  final String? personalIdImage;

  PendingUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.image,
    this.idNumber,
    this.personalIdImage,
  });

  factory PendingUserModel.fromJson(Map<String, dynamic> json) {
    return PendingUserModel(
      id: json["id"],
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      role: json["role"] ?? "",

      image: json["image"],

      idNumber: json["id_number"],
      personalIdImage: json["personal_id_image"],
    );
  }
}
