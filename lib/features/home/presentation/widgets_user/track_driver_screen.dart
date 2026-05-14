import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:resq_app/core/error/app_logger.dart';
import 'package:resq_app/core/error/error_handler.dart';
import 'package:resq_app/core/network/dio_client.dart';
import 'package:resq_app/features/map/services/location_service.dart';

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
  final LocationService _locationService = LocationService();

  GoogleMapController? mapController;
  LatLng? driverLocation;
  LatLng? lastRouteDriverLocation;
  late LatLng userLocation;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  String? etaText;
  bool driverArrived = false;
  String status = "pending";
  String infoMessage = "Preparing live tracking...";
  Timer? trackingTimer;

  @override
  void initState() {
    super.initState();
    userLocation = LatLng(widget.userLat, widget.userLng);
    _getTracking();

    trackingTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _getTracking(),
    );
  }

  @override
  void dispose() {
    trackingTimer?.cancel();
    mapController?.dispose();
    super.dispose();
  }

  Future<void> _getTracking() async {
    try {
      final response = await dio.get("/emergency/track-driver/${widget.requestId}");
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const FormatException('Tracking response is invalid.');
      }

      status = data["request_status"]?.toString() ?? "pending";

      if (status == "completed") {
        if (!mounted) return;

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Trip completed successfully.")),
        );
        return;
      }

      if (status == "accepted") {
        if (!mounted) return;
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
          etaText = null;
          infoMessage = "Driver is preparing to move.";
        });
        return;
      }

      final driver = data["driver_location"];
      if (driver is! Map<String, dynamic>) {
        return;
      }

      double driverLat = double.tryParse(driver["lat"].toString()) ?? 0;
      double driverLng = double.tryParse(driver["lng"].toString()) ?? 0;

      if (driverLat == userLocation.latitude && driverLng == userLocation.longitude) {
        driverLat += 0.0005;
        driverLng += 0.0005;
      }

      final newDriverLocation = LatLng(driverLat, driverLng);
      if (!mounted) return;

      driverLocation = newDriverLocation;
      _updateMarkers();

      var shouldRequestRoute = false;
      if (lastRouteDriverLocation == null) {
        shouldRequestRoute = true;
      } else {
        final movedDistance = Geolocator.distanceBetween(
          lastRouteDriverLocation!.latitude,
          lastRouteDriverLocation!.longitude,
          driverLocation!.latitude,
          driverLocation!.longitude,
        );
        shouldRequestRoute = movedDistance > 20;
      }

      if (shouldRequestRoute) {
        lastRouteDriverLocation = driverLocation;
        await _getRouteAndEta();
      }
    } catch (error, stackTrace) {
      final appException = ErrorHandler.handle(error, stackTrace: stackTrace);
      AppLogger.error(
        'Track driver flow failed.',
        name: 'TrackDriverScreen',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) return;
      setState(() {
        infoMessage = appException.userMessage;
      });
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
      final routeData = await _locationService.getRouteData(
        driverLocation!.latitude,
        driverLocation!.longitude,
        userLocation.latitude,
        userLocation.longitude,
      );

      final distance = Geolocator.distanceBetween(
        driverLocation!.latitude,
        driverLocation!.longitude,
        userLocation.latitude,
        userLocation.longitude,
      );

      driverArrived = distance < 15;

      if (!mounted) return;
      setState(() {
        polylines = routeData == null
            ? {}
            : {
                Polyline(
                  polylineId: const PolylineId("route"),
                  points: routeData.points,
                  width: 5,
                  color: Colors.blue,
                ),
              };
        etaText = routeData?.eta;
        infoMessage = driverArrived
            ? "Driver has arrived"
            : (routeData?.eta != null
                ? "Driver arriving in ${routeData!.eta}"
                : "Driver is on the way.");
      });

      _moveCamera();
    } catch (error, stackTrace) {
      AppLogger.error(
        'Track driver route fetch failed.',
        name: 'TrackDriverScreen',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void _moveCamera() {
    if (driverLocation == null || mapController == null) {
      return;
    }

    final bounds = LatLngBounds(
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
      CameraUpdate.newLatLngBounds(bounds, 80),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bannerText = status == "accepted"
        ? "Driver is preparing..."
        : driverArrived
            ? "Driver has arrived"
            : etaText != null
                ? "Driver arriving in $etaText"
                : infoMessage;

    return Scaffold(
      backgroundColor: const Color(0xFF07142A),
      appBar: AppBar(
        title: const Text("Track Driver"),
      ),
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
                bannerText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
