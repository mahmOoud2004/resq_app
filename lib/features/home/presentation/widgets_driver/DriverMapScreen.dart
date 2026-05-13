import 'dart:async';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:resq_app/core/network/dio_client.dart';

import 'package:resq_app/features/navigation/presentation/screen/driver_main_screens.dart';

class DriverMapScreen extends StatefulWidget {
  final double userLat;
  final double userLng;

  const DriverMapScreen({
    super.key,
    required this.userLat,
    required this.userLng,
  });

  @override
  State<DriverMapScreen> createState() => _DriverMapScreenState();
}

class _DriverMapScreenState extends State<DriverMapScreen> {
  final dio = DioClient().dio;

  GoogleMapController? mapController;

  LatLng? driverLocation;

  StreamSubscription<Position>? stream;

  Timer? locationTimer;

  bool isSending = false;

  @override
  void initState() {
    super.initState();

    _startDriverTracking();
  }

  Future<void> _startDriverTracking() async {
    try {
      debugPrint("🚑 DRIVER TRACKING STARTED");

      /// Permissions
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint(
          "❌ LOCATION PERMISSION DENIED FOREVER",
        );

        return;
      }

      /// Initial Position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _updateDriverLocation(position);

      /// Live Stream
      stream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
        ),
      ).listen(
        (position) {
          _updateDriverLocation(position);
        },
        onError: (e) {
          debugPrint(
            "❌ LOCATION STREAM ERROR => $e",
          );
        },
      );

      /// 🔥 SEND LOCATION EVERY 5 SECONDS
      locationTimer = Timer.periodic(
        const Duration(seconds: 5),
        (_) async {
          if (driverLocation == null) return;

          await _sendDriverLocation(
            driverLocation!.latitude,
            driverLocation!.longitude,
          );
        },
      );
    } catch (e) {
      debugPrint(
        "❌ DRIVER MAP ERROR => $e",
      );
    }
  }

  Future<void> _sendDriverLocation(
    double lat,
    double lng,
  ) async {
    if (isSending) return;

    try {
      isSending = true;

      debugPrint(
        "📡 SENDING DRIVER LOCATION => "
        "$lat, $lng",
      );

      final response = await dio.post(
        "/driver/update-location",
        data: {
          "latitude": lat,
          "longitude": lng,
        },
      );

      debugPrint(
        "✅ DRIVER LOCATION SENT => "
        "${response.data}",
      );
    } catch (e) {
      debugPrint(
        "❌ SEND DRIVER LOCATION ERROR => $e",
      );
    } finally {
      isSending = false;
    }
  }

  void _updateDriverLocation(
    Position position,
  ) {
    double lat = position.latitude;
    double lng = position.longitude;

    /// حل مشكلة نفس المكان أثناء التست
    if (lat == widget.userLat && lng == widget.userLng) {
      debugPrint(
        "⚠️ DRIVER & USER SAME PLACE",
      );

      lat += 0.0007;
      lng += 0.0007;
    }

    driverLocation = LatLng(lat, lng);

    debugPrint(
      "🚑 DRIVER LIVE LOCATION => "
      "${driverLocation!.latitude}, "
      "${driverLocation!.longitude}",
    );

    setState(() {});

    _moveCamera();
  }

  void _moveCamera() {
    if (mapController == null || driverLocation == null) {
      return;
    }

    final userLocation = LatLng(
      widget.userLat,
      widget.userLng,
    );

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

    mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        bounds,
        100,
      ),
    );
  }

  @override
  void dispose() {
    debugPrint(
      "🛑 DRIVER TRACKING STOPPED",
    );

    stream?.cancel();

    locationTimer?.cancel();

    mapController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userLocation = LatLng(
      widget.userLat,
      widget.userLng,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Emergency Map",
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const DriverMainScreen(),
              ),
              (route) => false,
            );
          },
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: userLocation,
          zoom: 15,
        ),
        onMapCreated: (controller) {
          mapController = controller;

          debugPrint(
            "🗺 DRIVER MAP CREATED",
          );
        },
        markers: {
          /// USER
          Marker(
            markerId: const MarkerId(
              "user_location",
            ),
            position: userLocation,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
            infoWindow: const InfoWindow(
              title: "User Location",
            ),
          ),

          /// DRIVER
          if (driverLocation != null)
            Marker(
              markerId: const MarkerId(
                "driver_location",
              ),
              position: driverLocation!,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
              infoWindow: const InfoWindow(
                title: "Driver",
              ),
            ),
        },
        polylines: {
          if (driverLocation != null)
            Polyline(
              polylineId: const PolylineId(
                "route",
              ),
              points: [
                driverLocation!,
                userLocation,
              ],
              width: 5,
              color: Colors.blue,
            ),
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
      ),
    );
  }
}
