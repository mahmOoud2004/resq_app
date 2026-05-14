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
      id: json["id"] is int ? json["id"] as int : int.tryParse('${json["id"]}') ?? 0,
      status: json["status"]?.toString() ?? "",
      serviceType: json["service_type"]?.toString() ?? "",
      lat: double.tryParse(json["latitude"].toString()) ?? 0,
      lng: double.tryParse(json["longitude"].toString()) ?? 0,
      driverName: driver is Map ? driver["name"]?.toString() : null,
      driverPhone: driver is Map ? driver["phone"]?.toString() : null,
    );
  }
}
