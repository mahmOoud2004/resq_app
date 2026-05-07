import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class DriverMapCard extends StatefulWidget {
  const DriverMapCard({super.key});

  @override
  State<DriverMapCard> createState() => _DriverMapCardState();
}

class _DriverMapCardState extends State<DriverMapCard> {
  LatLng? driverLocation;
  final MapController _mapController = MapController();

  Timer? timer;

  @override
  void initState() {
    super.initState();

    _getDriverLocation();

    /// 🔥 تحديث كل 5 ثواني
    timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _getDriverLocation();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
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
      });

      _mapController.move(newLocation, 15);
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
          color: Colors.black12,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      height: 200,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.hardEdge,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(initialCenter: driverLocation!, initialZoom: 15),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.resq.app',
          ),

          MarkerLayer(
            markers: [
              Marker(
                point: driverLocation!,
                width: 60,
                height: 60,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Icon(
                    Icons.local_taxi,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
