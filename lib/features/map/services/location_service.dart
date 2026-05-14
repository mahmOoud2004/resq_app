import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resq_app/core/error/app_exception.dart';
import 'package:resq_app/core/error/app_logger.dart';
import 'package:resq_app/core/error/error_handler.dart';
import 'package:resq_app/core/network/api_constants.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw const AppException(
        code: 'location_services_disabled',
        userMessage: 'Location services are turned off. Please enable them and try again.',
        developerMessage: 'Location services are disabled.',
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const AppException(
        code: 'location_permission_denied',
        userMessage: 'Location permission is required to continue.',
        developerMessage: 'Location permission denied by user.',
      );
    }

    if (permission == LocationPermission.deniedForever) {
      throw const AppException(
        code: 'location_permission_denied_forever',
        userMessage:
            'Location permission was permanently denied. Please enable it from settings.',
        developerMessage: 'Location permission denied forever.',
      );
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).timeout(const Duration(seconds: 20));
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
    try {
      final placemarks = await placemarkFromCoordinates(
        lat,
        lng,
      ).timeout(const Duration(seconds: 10));

      if (placemarks.isEmpty) {
        return 'Current location';
      }

      final place = placemarks.first;
      final city = place.locality?.trim() ?? '';
      final area = place.subLocality?.trim() ?? '';
      final address = [city, area].where((value) => value.isNotEmpty).join(' - ');

      return address.isEmpty ? 'Current location' : address;
    } catch (error, stackTrace) {
      final appException = ErrorHandler.handle(error);
      AppLogger.warning(
        appException.developerMessage,
        name: 'LocationService',
        error: error,
      );
      AppLogger.debug(stackTrace.toString(), name: 'LocationService');
      return 'Current location';
    }
  }

  Future<RouteData?> getRouteData(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) async {
    try {
      final apiKey = dotenv.env[ApiConstants.googleMapsApiKeyEnv]?.trim();
      if (apiKey == null || apiKey.isEmpty) {
        AppLogger.warning(
          'Google Maps API key is missing. Skipping route fetch.',
          name: 'LocationService',
        );
        return null;
      }

      final url =
          "https://maps.googleapis.com/maps/api/directions/json?"
          "origin=$startLat,$startLng"
          "&destination=$endLat,$endLng"
          "&key=$apiKey";

      final response = await Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      ).get(url);

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
          List<PointLatLng> result = PolylinePoints.decodePolyline(
            route['overview_polyline']['points'],
          );

          points = result.map((p) => LatLng(p.latitude, p.longitude)).toList();
        }

        return RouteData(eta: eta, points: points);
      }
    } catch (error, stackTrace) {
      final appException = ErrorHandler.handle(error);
      AppLogger.warning(
        appException.developerMessage,
        name: 'LocationService',
        error: error,
      );
      AppLogger.debug(stackTrace.toString(), name: 'LocationService');
    }

    return null;
  }
}

class RouteData {
  final String eta;
  final List<LatLng> points;

  RouteData({required this.eta, required this.points});
}
