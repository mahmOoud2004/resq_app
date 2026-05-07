class ActiveRequestModel {
  final int id;
  final String status;
  final String serviceType;
  final double lat;
  final double lng;
  final String? driverName;
  final String? driverPhone;

  ActiveRequestModel({
    required this.id,
    required this.status,
    required this.serviceType,
    required this.lat,
    required this.lng,
    this.driverName,
    this.driverPhone,
  });

  factory ActiveRequestModel.fromJson(Map<String, dynamic> json) {
    final driver = json["driver"];

    return ActiveRequestModel(
      id: json["id"],
      status: json["status"],
      serviceType: json["service_type"],
      lat: double.parse(json["latitude"]),
      lng: double.parse(json["longitude"]),
      driverName: driver?["name"],
      driverPhone: driver?["phone"],
    );
  }
}
