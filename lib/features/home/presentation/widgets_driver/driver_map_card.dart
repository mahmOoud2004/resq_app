import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:resq_app/core/constants/app_color.dart';
import 'package:resq_app/core/error/app_logger.dart';
import 'package:resq_app/features/map/services/location_service.dart';

class DriverMapCard extends StatefulWidget {
  const DriverMapCard({super.key});

  @override
  State<DriverMapCard> createState() => _DriverMapCardState();
}

class _DriverMapCardState extends State<DriverMapCard> {
  final LocationService _locationService = LocationService();

  LatLng? driverLocation;
  GoogleMapController? mapController;
  Timer? timer;
  Set<Marker> markers = {};
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _getDriverLocation();

    timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _getDriverLocation(),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    mapController?.dispose();
    super.dispose();
  }

  Future<void> _getDriverLocation() async {
    try {
      final position = await _locationService.getCurrentLocation();
      final newLocation = LatLng(position.latitude, position.longitude);

      if (!mounted) return;

      setState(() {
        driverLocation = newLocation;
        errorMessage = null;
        markers = {
          Marker(
            markerId: const MarkerId("driver"),
            position: newLocation,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        };
      });

      mapController?.animateCamera(CameraUpdate.newLatLng(newLocation));
    } catch (error, stackTrace) {
      AppLogger.error(
        'Driver map location failed.',
        name: 'DriverMapCard',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) return;
      setState(() {
        errorMessage = 'Unable to load driver location right now.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (driverLocation == null) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Center(
          child: errorMessage == null
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
        ),
      );
    }

    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.hardEdge,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: driverLocation!,
          zoom: 15,
        ),
        onMapCreated: (controller) {
          mapController = controller;
        },
        markers: markers,
        zoomControlsEnabled: false,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
      ),
    );
  }
}
