class LoginResponseModel {
  final String? token;
  final String role;
  final String message;

  LoginResponseModel({
    required this.token,
    required this.role,
    required this.message,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['access_token'] as String?,
      role: json['role'] ?? "",
      message: json['message'] ?? "",
    );
  }
}
