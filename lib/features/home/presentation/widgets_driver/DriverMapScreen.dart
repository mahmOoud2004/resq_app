import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: userLocation, zoom: 15),

      markers: {
        Marker(
          markerId: const MarkerId("user_location"),

          position: userLocation,

          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),

          infoWindow: const InfoWindow(title: "User Location"),
        ),
      },

      myLocationEnabled: true,

      myLocationButtonEnabled: true,

      zoomControlsEnabled: false,
    );
  }
}
