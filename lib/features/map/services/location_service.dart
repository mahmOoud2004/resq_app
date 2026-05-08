import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw Exception("Location services are disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception("Location permission denied");
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permanently denied");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

    Placemark place = placemarks.first;

    String city = place.locality ?? "";
    String area = place.subLocality ?? "";

    return "$city - $area";
  }

  static const String _googleApiKey = "AIzaSyAAb4fRMVjSBKfk71ejiHrWdFkHiJ72Nhg";

  Future<RouteData?> getRouteData(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) async {
    try {
      final url =
          "https://maps.googleapis.com/maps/api/directions/json?"
          "origin=$startLat,$startLng"
          "&destination=$endLat,$endLng"
          "&key=$_googleApiKey";

      final response = await Dio().get(url);

      if (response.statusCode == 200 &&
          response.data['routes'] != null &&
          response.data['routes'].isNotEmpty) {
        final route = response.data['routes'][0];

        final leg = route['legs'][0];

        // ETA
        String eta = leg['duration']['text'];

        // Polyline
        List<LatLng> points = [];

        if (route['overview_polyline'] != null &&
            route['overview_polyline']['points'] != null) {
          PolylinePoints polylinePoints = PolylinePoints(apiKey: _googleApiKey);

          List<PointLatLng> result = PolylinePoints.decodePolyline(
            route['overview_polyline']['points'],
          );

          points = result.map((p) => LatLng(p.latitude, p.longitude)).toList();
        }

        return RouteData(eta: eta, points: points);
      }
    } catch (e) {
      // ignore errors
    }

    return null;
  }
}

class RouteData {
  final String eta;
  final List<LatLng> points;

  RouteData({required this.eta, required this.points});
}
