import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:resq_app/core/network/dio_client.dart';

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

  GoogleMapController? mapController;

  LatLng? driverLocation;
  LatLng? lastRouteDriverLocation;

  late LatLng userLocation;

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  int etaMinutes = 0;
  bool driverArrived = false;

  String status = "pending";

  Timer? timer;

  @override
  void initState() {
    super.initState();

    userLocation = LatLng(widget.userLat, widget.userLng);

    _getTracking();

    /// 🔥 كل 10 ثواني بدل 3
    timer = Timer.periodic(const Duration(seconds: 10), (_) => _getTracking());
  }

  @override
  void dispose() {
    timer?.cancel();
    mapController?.dispose();
    super.dispose();
  }

  Future<void> _getTracking() async {
    try {
      final response = await dio.get(
        "/emergency/track-driver/${widget.requestId}",
      );

      final data = response.data;

      status = data["request_status"] ?? "pending";

      /// ✅ الرحلة انتهت
      if (status == "completed") {
        if (!mounted) return;

        Navigator.pop(context);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Trip Completed ✅")));

        return;
      }

      /// 🚑 السواق قبل الطلب لكن لسه متحركش
      if (status == "accepted") {
        setState(() {
          driverLocation = null;

          polylines.clear();

          markers = {
            Marker(
              markerId: const MarkerId("user"),
              position: userLocation,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue,
              ),
            ),
          };

          etaMinutes = 0;
        });

        return;
      }

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

      driverLocation = newDriverLocation;

      _updateMarkers();

      /// 🔥 طلب route فقط عند الحركة الكبيرة
      if (status == "on_way") {
        bool shouldRequestRoute = false;

        if (lastRouteDriverLocation == null) {
          shouldRequestRoute = true;
        } else {
          double movedDistance = Geolocator.distanceBetween(
            lastRouteDriverLocation!.latitude,
            lastRouteDriverLocation!.longitude,
            driverLocation!.latitude,
            driverLocation!.longitude,
          );

          /// 🔥 لو اتحرك أكتر من 100 متر
          if (movedDistance > 100) {
            shouldRequestRoute = true;
          }
        }

        if (shouldRequestRoute) {
          lastRouteDriverLocation = driverLocation;

          _getRouteAndEta();
        }
      }
    } catch (e) {
      debugPrint("TRACK ERROR: $e");
    }
  }

  void _updateMarkers() {
    markers = {
      Marker(
        markerId: const MarkerId("user"),
        position: userLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),

      if (driverLocation != null)
        Marker(
          markerId: const MarkerId("driver"),
          position: driverLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
    };

    setState(() {});
  }

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

      List<LatLng> points = coords.map<LatLng>((e) {
        return LatLng(e[1], e[0]);
      }).toList();

      /// 🔥 حساب الوصول
      double distance = Geolocator.distanceBetween(
        driverLocation!.latitude,
        driverLocation!.longitude,
        userLocation.latitude,
        userLocation.longitude,
      );

      if (distance < 15) {
        driverArrived = true;
      } else {
        driverArrived = false;
      }

      setState(() {
        polylines = {
          Polyline(
            polylineId: const PolylineId("route"),
            points: points,
            width: 5,
            color: Colors.blue,
          ),
        };

        etaMinutes = (duration / 60).round();
      });

      _moveCamera();
    } catch (e) {
      debugPrint("ROUTE ERROR: $e");
    }
  }

  void _moveCamera() {
    if (driverLocation == null || mapController == null) return;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        driverLocation!.latitude < userLocation.latitude
            ? driverLocation!.latitude
            : userLocation.latitude,

        driverLocation!.longitude < userLocation.longitude
            ? driverLocation!.longitude
            : userLocation.longitude,
      ),

      northeast: LatLng(
        driverLocation!.latitude > userLocation.latitude
            ? driverLocation!.latitude
            : userLocation.latitude,

        driverLocation!.longitude > userLocation.longitude
            ? driverLocation!.longitude
            : userLocation.longitude,
      ),
    );

    mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07142A),

      appBar: AppBar(title: const Text("Track Driver")),

      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: userLocation,
              zoom: 15,
            ),

            onMapCreated: (controller) {
              mapController = controller;
            },

            markers: markers,

            polylines: polylines,

            myLocationEnabled: true,

            myLocationButtonEnabled: true,

            zoomControlsEnabled: false,
          ),

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
