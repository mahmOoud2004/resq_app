class EmergencyRequestModel {
  final String serviceType;
  final double latitude;
  final double longitude;

  EmergencyRequestModel({
    required this.serviceType,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      "service_type": serviceType,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}
