import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:resq_app/core/network/dio_client.dart';
import 'package:resq_app/features/map/presentation/cubit/tracking_state.dart';
import 'package:resq_app/features/map/services/location_service.dart';

class TrackingCubit extends Cubit<TrackingState> {
  final LocationService _locationService;

  final dio = DioClient().dio;

  StreamSubscription<Position>? _locationSubscription;

  Timer? _driverTimer;
  Timer? _routeTimer;

  int? currentRequestId;

  TrackingCubit(this._locationService) : super(const TrackingState()) {
    _initUserLocation();
  }

  Future<void> _initUserLocation() async {
    try {
      debugPrint("📍 Getting user location...");

      final position = await _locationService.getCurrentLocation();

      final userLocation = LatLng(
        position.latitude,
        position.longitude,
      );

      debugPrint(
        "✅ USER LOCATION => "
        "${userLocation.latitude}, "
        "${userLocation.longitude}",
      );

      emit(
        state.copyWith(
          userLocation: userLocation,
          isLoading: false,
        ),
      );

      _locationSubscription = _locationService.getLocationStream().listen(
        (position) {
          final updatedLocation = LatLng(
            position.latitude,
            position.longitude,
          );

          debugPrint(
            "🔄 USER LOCATION UPDATED => "
            "${updatedLocation.latitude}, "
            "${updatedLocation.longitude}",
          );

          emit(
            state.copyWith(
              userLocation: updatedLocation,
            ),
          );
        },
        onError: (e) {
          debugPrint("❌ LOCATION STREAM ERROR => $e");

          emit(
            state.copyWith(
              error: "Location stream error",
            ),
          );
        },
      );
    } catch (e) {
      debugPrint("❌ INIT LOCATION ERROR => $e");

      emit(
        state.copyWith(
          isLoading: false,
          error: "Location error",
        ),
      );
    }
  }

  void startTrackingDriver(int requestId) {
    if (currentRequestId == requestId) return;

    debugPrint("🚑 START TRACKING DRIVER => $requestId");

    currentRequestId = requestId;

    _driverTimer?.cancel();
    _routeTimer?.cancel();

    _fetchDriverLocation();
    _fetchRouteAndEta();

    /// Driver location update
    _driverTimer = Timer.periodic(
      const Duration(seconds: 8),
      (_) => _fetchDriverLocation(),
    );

    /// Route update
    _routeTimer = Timer.periodic(
      const Duration(seconds: 20),
      (_) => _fetchRouteAndEta(),
    );
  }

  Future<void> _fetchDriverLocation() async {
    if (currentRequestId == null) return;

    try {
      debugPrint(
        "🚑 FETCH DRIVER LOCATION => $currentRequestId",
      );

      final response = await dio.get(
        "/emergency/track-driver/$currentRequestId",
      );

      final driver = response.data["driver_location"];

      if (driver == null) {
        debugPrint("⚠️ DRIVER LOCATION IS NULL");
        return;
      }

      double lat = double.parse(driver["lat"]);
      double lng = double.parse(driver["lng"]);

      /// 🔥 حل مشكلة نفس المكان
      if (state.userLocation != null) {
        if (lat == state.userLocation!.latitude &&
            lng == state.userLocation!.longitude) {
          debugPrint(
            "⚠️ DRIVER & USER SAME LOCATION => APPLYING OFFSET",
          );

          lat += 0.0007;
          lng += 0.0007;
        }
      }

      final driverLocation = LatLng(lat, lng);

      debugPrint(
        "🚑 DRIVER LOCATION => "
        "${driverLocation.latitude}, "
        "${driverLocation.longitude}",
      );

      emit(
        state.copyWith(
          driverLocation: driverLocation,
        ),
      );
    } catch (e) {
      debugPrint("❌ DRIVER TRACK ERROR => $e");
    }
  }

  Future<void> _fetchRouteAndEta() async {
    if (state.driverLocation == null || state.userLocation == null) {
      return;
    }

    try {
      debugPrint("🛣 FETCH ROUTE & ETA");

      final routeData = await _locationService.getRouteData(
        state.driverLocation!.latitude,
        state.driverLocation!.longitude,
        state.userLocation!.latitude,
        state.userLocation!.longitude,
      );

      if (routeData != null) {
        debugPrint(
          "✅ ETA => ${routeData.eta}",
        );

        debugPrint(
          "✅ ROUTE POINTS => ${routeData.points.length}",
        );

        emit(
          state.copyWith(
            eta: routeData.eta,
            routePoints: routeData.points,
          ),
        );
      }
    } catch (e) {
      debugPrint("❌ ROUTE ERROR => $e");
    }
  }

  @override
  Future<void> close() {
    debugPrint("🛑 TRACKING CUBIT CLOSED");

    _locationSubscription?.cancel();
    _driverTimer?.cancel();
    _routeTimer?.cancel();

    return super.close();
  }
}
