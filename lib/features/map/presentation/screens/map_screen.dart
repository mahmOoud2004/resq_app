import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:resq_app/core/network/dio_client.dart';
import 'package:resq_app/features/emergency/presentation/bloc/emergency_bloc.dart';
import 'package:resq_app/features/map/presentation/widgets/driver_bottom_card.dart';
import 'package:resq_app/features/map/presentation/widgets/user_location_marker.dart';

import '../../services/location_service.dart';

class MapScreen extends StatefulWidget {
  final double? lat;
  final double? lng;

  const MapScreen({super.key, this.lat, this.lng});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LocationService _locationService = LocationService();
  final MapController _mapController = MapController();

  LatLng? userLocation;
  LatLng? driverLocation;

  bool isViewingDriver = false;

  Timer? timer;
  bool isLoading = true;

  int? currentRequestId;

  final dio = DioClient().dio;

  @override
  void initState() {
    super.initState();

    if (widget.lat != null && widget.lng != null) {
      userLocation = LatLng(widget.lat!, widget.lng!);
      isLoading = false;
    } else {
      _initLocation();
    }

    /// 🔥 اسحب الريكوست
    context.read<EmergencyBloc>().add(GetActiveRequestEvent());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  /// ================= LOCATION =================

  Future<void> _initLocation() async {
    try {
      await _getLocation();

      timer = Timer.periodic(const Duration(seconds: 5), (_) {
        _getLocation();
      });
    } catch (e) {
      _showError();
    }
  }

  Future<void> _getLocation() async {
    try {
      Position position = await _locationService.getCurrentLocation();

      final newLocation = LatLng(position.latitude, position.longitude);

      if (!mounted) return;

      setState(() {
        userLocation = newLocation;
        isLoading = false;
      });

      if (!isViewingDriver) {
        _mapController.move(newLocation, 15);
      }
    } catch (e) {
      _showError();
    }
  }

  /// ================= DRIVER TRACK =================

  void _startTrackingDriver(int requestId) {
    currentRequestId = requestId;

    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _getDriverLocation();
    });

    _getDriverLocation();
  }

  Future<void> _getDriverLocation() async {
    if (currentRequestId == null) return;

    try {
      final response = await dio.get(
        "/emergency/track-driver/$currentRequestId",
      );

      final data = response.data;

      final driver = data["driver_location"];

      if (driver == null) return;

      final lat = double.parse(driver["lat"]);
      final lng = double.parse(driver["lng"]);

      if (!mounted) return;

      final newDriverLocation = LatLng(lat, lng);

      setState(() {
        driverLocation = newDriverLocation;
      });

      /// لو بتتبع السواق
      if (isViewingDriver) {
        _mapController.move(newDriverLocation, 15);
      }
    } catch (e) {
      debugPrint("Driver Location Error: $e");
    }
  }

  void _showError() {
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Location error")));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmergencyBloc, EmergencyState>(
      builder: (context, state) {
        String? driverName;
        String? driverPhone;
        String? status;

        if (state is EmergencyHasActiveRequest) {
          driverName = state.request.driverName;
          driverPhone = state.request.driverPhone;
          status = state.request.status;

          /// 🔥 ابدأ التتبع
          if (currentRequestId != state.request.id) {
            _startTrackingDriver(state.request.id);
          }
        }

        return _buildMap(driverName, driverPhone, status);
      },
    );
  }

  Widget _buildMap(String? driverName, String? driverPhone, String? status) {
    if (isLoading || userLocation == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    bool showDriverCard = status == "accepted" || status == "on_way";

    return Scaffold(
      backgroundColor: const Color(0xFF07142A),

      body: Stack(
        children: [
          /// ================= MAP =================
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: userLocation!, initialZoom: 15),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.resq.app',
              ),

              MarkerLayer(
                markers: [
                  /// 🔵 USER
                  if (!isViewingDriver)
                    Marker(
                      point: userLocation!,
                      width: 60,
                      height: 60,
                      child: const UserLocationMarker(),
                    ),

                  /// 🔴 DRIVER
                  if (driverLocation != null)
                    Marker(
                      point: driverLocation!,
                      width: 60,
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: const Icon(
                          Icons.local_taxi,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),

          /// ================= BUTTON =================
          Positioned(
            bottom: 120,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: isViewingDriver
                  ? Colors.red
                  : const Color(0xFF2E5BFF),
              onPressed: () {
                if (driverLocation == null) return;

                setState(() {
                  isViewingDriver = !isViewingDriver;
                });

                if (isViewingDriver) {
                  _mapController.move(driverLocation!, 15);
                } else {
                  _mapController.move(userLocation!, 15);
                }
              },
              child: Icon(isViewingDriver ? Icons.person : Icons.local_taxi),
            ),
          ),

          /// ================= DRIVER CARD =================
          if (showDriverCard)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: DriverBottomCard(name: driverName, phone: driverPhone),
            ),
        ],
      ),
    );
  }
}
