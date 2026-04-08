import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../../services/location_service.dart';
import '../widgets/user_location_marker.dart';

class MapScreen extends StatefulWidget {
  final double? lat;
  final double? lng;

  const MapScreen({super.key, this.lat, this.lng});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LocationService _locationService = LocationService();

  LatLng? userLocation;

  @override
  void initState() {
    super.initState();

    /// لو وصل lat/lng من برا
    if (widget.lat != null && widget.lng != null) {
      userLocation = LatLng(widget.lat!, widget.lng!);
    } else {
      _getLocation();
    }
  }

  Future<void> _getLocation() async {
    try {
      Position position = await _locationService.getCurrentLocation();

      if (!mounted) return;

      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enable location to use the map")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return FlutterMap(
      options: MapOptions(initialCenter: userLocation!, initialZoom: 15),

      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: 'com.resq.app',
        ),

        MarkerLayer(
          markers: [
            Marker(
              point: userLocation!,
              width: 60,
              height: 60,
              child: const UserLocationMarker(),
            ),
          ],
        ),
      ],
    );
  }
}
