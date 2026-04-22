class EmergencyModel {
  final int id;
  final String serviceType;
  final String status;

  final String userName;
  final String phone;
  final String? userImage;

  final String? driverName;

  final String latitude;
  final String longitude;

  final String createdAt;

  EmergencyModel({
    required this.id,
    required this.serviceType,
    required this.status,
    required this.userName,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    this.userImage,
    this.driverName,
  });

  factory EmergencyModel.fromJson(Map<String, dynamic> json) {
    return EmergencyModel(
      id: json["id"] ?? 0,
      serviceType: json["service_type"] ?? "",
      status: json["status"] ?? "",

      /// user
      userName: json["user"]?["name"] ?? "",
      phone: json["user"]?["phone"] ?? "",
      userImage: json["user"]?["image"],

      /// driver
      driverName: json["driver"]?["name"],

      /// 🔥 الحل هنا
      latitude: json["latitude"]?.toString() ?? "",
      longitude: json["longitude"]?.toString() ?? "",

      /// date
      createdAt: json["created_at"] ?? "",
    );
  }
}
