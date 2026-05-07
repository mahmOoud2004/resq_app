class DriverRequestModel {
  final int id;
  final String serviceType;
  final double latitude;
  final double longitude;

  /// 🔥 الجديد
  final String? userName;
  final String? userPhone;

  DriverRequestModel({
    required this.id,
    required this.serviceType,
    required this.latitude,
    required this.longitude,
    this.userName,
    this.userPhone,
  });

  factory DriverRequestModel.fromJson(Map<String, dynamic> json) {
    return DriverRequestModel(
      id: json['id'],
      serviceType: json['service_type'] ?? "",
      latitude: double.tryParse(json['latitude'].toString()) ?? 0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0,

      /// 🔥 حسب API
      userName: json['user']?['name'],
      userPhone: json['user']?['phone'],
    );
  }
}
