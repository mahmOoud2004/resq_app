class DriverRequestModel {
  final int id;
  final String serviceType;
  final double latitude;
  final double longitude;

  DriverRequestModel({
    required this.id,
    required this.serviceType,
    required this.latitude,
    required this.longitude,
  });

  factory DriverRequestModel.fromJson(Map<String, dynamic> json) {
    return DriverRequestModel(
      id: json['id'],
      serviceType: json['service_type'] ?? "",
      latitude: double.tryParse(json['latitude'].toString()) ?? 0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0,
    );
  }
}
