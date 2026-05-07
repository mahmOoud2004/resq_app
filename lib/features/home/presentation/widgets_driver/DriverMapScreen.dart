import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DriverMapScreen extends StatelessWidget {
  final double userLat;
  final double userLng;

  const DriverMapScreen({
    super.key,
    required this.userLat,
    required this.userLng,
  });

  @override
  Widget build(BuildContext context) {
    final userLocation = LatLng(userLat, userLng);

    return FlutterMap(
      options: MapOptions(initialCenter: userLocation, initialZoom: 15),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: 'com.resq.app',
        ),

        MarkerLayer(
          markers: [
            /// 🔴 USER LOCATION
            Marker(
              point: userLocation,
              width: 60,
              height: 60,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
