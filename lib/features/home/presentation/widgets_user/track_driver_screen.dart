import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:latlong2/latlong.dart' show Distance, LengthUnit;
import 'package:resq_app/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class TrackDriverScreen extends StatefulWidget {
  final int requestId;
  final double userLat;
  final double userLng;

  const TrackDriverScreen({
    super.key,
    required this.requestId,
    required this.userLat,
    required this.userLng,
  });

  @override
  State<TrackDriverScreen> createState() => _TrackDriverScreenState();
}

class _TrackDriverScreenState extends State<TrackDriverScreen> {
  final dio = DioClient().dio;

  LatLng? driverLocation;
  late LatLng userLocation;

  List<LatLng> routePoints = [];
  int etaMinutes = 0;
  bool driverArrived = false;

  String status = "pending"; // 🔥 الحالة

  Timer? timer;

  @override
  void initState() {
    super.initState();

    userLocation = LatLng(widget.userLat, widget.userLng);

    _getTracking();

    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _getTracking();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  /// 🔥 جلب الداتا
  Future<void> _getTracking() async {
    try {
      final response = await dio.get(
        "/emergency/track-driver/${widget.requestId}",
      );

      final data = response.data;

      status = data["request_status"] ?? "pending";

      /// ✅ لو خلص
      if (status == "completed") {
        if (!mounted) return;

        Navigator.pop(context);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Trip Completed ✅")));
        return;
      }

      /// 🚫 لو لسه accepted → مفيش سواق
      if (status == "accepted") {
        setState(() {
          driverLocation = null;
          routePoints = [];
          etaMinutes = 0;
        });
        return;
      }

      /// ✅ on_way → نعرض السواق
      final driver = data["driver_location"];
      if (driver == null) return;

      double driverLat = double.parse(driver["lat"]);
      double driverLng = double.parse(driver["lng"]);

      /// 🔥 حل مشكلة نفس المكان
      if (driverLat == userLocation.latitude &&
          driverLng == userLocation.longitude) {
        driverLat += 0.0005;
        driverLng += 0.0005;
      }

      final newDriverLocation = LatLng(driverLat, driverLng);

      if (!mounted) return;

      setState(() {
        driverLocation = newDriverLocation;
      });

      /// 🔥 حساب المسافة
      double distance = const Distance().as(
        LengthUnit.Meter,
        driverLocation!,
        userLocation,
      );

      if (distance < 10) {
        setState(() {
          driverArrived = true;
          routePoints = [];
          etaMinutes = 0;
        });
        return;
      } else {
        driverArrived = false;
      }

      /// 🔥 نجيب الطريق بس لما يبقى on_way
      if (status == "on_way") {
        _getRouteAndEta();
      }
    } catch (e) {
      debugPrint("TRACK ERROR: $e");
    }
  }

  /// 🔥 جلب الطريق
  Future<void> _getRouteAndEta() async {
    if (driverLocation == null) return;

    try {
      final response = await Dio().get(
        "https://api.openrouteservice.org/v2/directions/driving-car",
        options: Options(headers: {"Authorization": "YOUR_API_KEY"}),
        queryParameters: {
          "start": "${driverLocation!.longitude},${driverLocation!.latitude}",
          "end": "${userLocation.longitude},${userLocation.latitude}",
        },
      );

      final coords = response.data["features"][0]["geometry"]["coordinates"];

      final duration =
          response.data["features"][0]["properties"]["summary"]["duration"];

      final points = coords.map<LatLng>((e) => LatLng(e[1], e[0])).toList();

      if (!mounted) return;

      setState(() {
        routePoints = points;
        etaMinutes = (duration / 60).round();
      });
    } catch (e) {
      debugPrint("ROUTE ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07142A),
      appBar: AppBar(title: const Text("Track Driver")),

      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(initialCenter: userLocation, initialZoom: 15),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.resq.app',
              ),

              /// 🔥 الطريق يظهر بس on_way
              if (routePoints.isNotEmpty && status == "on_way")
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      strokeWidth: 4,
                      color: Colors.blue,
                    ),
                  ],
                ),

              MarkerLayer(
                markers: [
                  /// 📍 user دايماً
                  Marker(
                    point: userLocation,
                    width: 50,
                    height: 50,
                    child: const Icon(
                      Icons.person_pin_circle,
                      color: Colors.blue,
                      size: 40,
                    ),
                  ),

                  /// 🚑 driver يظهر بس on_way
                  if (driverLocation != null && status == "on_way")
                    Marker(
                      point: driverLocation!,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.local_taxi,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                ],
              ),
            ],
          ),

          /// 🔥 ETA
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F2347),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                status == "accepted"
                    ? "🚑 Driver is preparing..."
                    : driverArrived
                    ? "🚑 Driver has arrived"
                    : (etaMinutes > 0
                          ? "🚑 Driver arriving in $etaMinutes min"
                          : "Calculating..."),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
