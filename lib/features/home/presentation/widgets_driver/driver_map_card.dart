import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:resq_app/core/constants/app_color.dart';

class DriverMapCard extends StatefulWidget {
  const DriverMapCard({super.key});

  @override
  State<DriverMapCard> createState() => _DriverMapCardState();
}

class _DriverMapCardState extends State<DriverMapCard> {
  LatLng? driverLocation;

  GoogleMapController? mapController;

  Timer? timer;

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();

    _getDriverLocation();

    /// 🔥 تحديث كل 5 ثواني
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
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final newLocation = LatLng(position.latitude, position.longitude);

      if (!mounted) return;

      setState(() {
        driverLocation = newLocation;

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
    } catch (e) {
      debugPrint("LOCATION ERROR: $e");
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

        child: const Center(child: CircularProgressIndicator()),
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
