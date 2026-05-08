import 'dart:async';
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
  Timer? _osrmTimer;

  int? currentRequestId;

  TrackingCubit(this._locationService) : super(const TrackingState()) {
    _initUserLocation();
  }

  Future<void> _initUserLocation() async {
    try {
      Position position = await _locationService.getCurrentLocation();
      final newLocation = LatLng(position.latitude, position.longitude);
      
      emit(state.copyWith(userLocation: newLocation, isLoading: false));

      _locationSubscription = _locationService.getLocationStream().listen(
        (Position position) {
          emit(state.copyWith(
            userLocation: LatLng(position.latitude, position.longitude),
          ));
        },
        onError: (e) {
          emit(state.copyWith(error: "Location stream error"));
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: "Location error"));
    }
  }

  void startTrackingDriver(int requestId) {
    if (currentRequestId == requestId) return;
    
    currentRequestId = requestId;
    _driverTimer?.cancel();
    _osrmTimer?.cancel();

    // Fetch driver location every 10 seconds to reduce backend load
    _driverTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _fetchDriverLocation();
    });

    // Fetch Route & ETA from OSRM every 60 seconds to avoid free-tier bans
    _osrmTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      _fetchRouteAndEta();
    });

    // Initial fetches
    _fetchDriverLocation();
    _fetchRouteAndEta();
  }

  Future<void> _fetchDriverLocation() async {
    if (currentRequestId == null) return;

    try {
      final response = await dio.get("/emergency/track-driver/$currentRequestId");
      final driver = response.data["driver_location"];
      if (driver == null) return;

      final lat = double.parse(driver["lat"]);
      final lng = double.parse(driver["lng"]);
      
      final newDriverLocation = LatLng(lat, lng);
      
      emit(state.copyWith(driverLocation: newDriverLocation));
      
      // If we don't have ETA yet, fetch it immediately
      if (state.eta == null && state.userLocation != null) {
        _fetchRouteAndEta();
      }
    } catch (e) {
      // Handle silently to not disrupt UI on polling failures
    }
  }

  Future<void> _fetchRouteAndEta() async {
    if (state.driverLocation == null || state.userLocation == null) return;

    try {
      final routeData = await _locationService.getRouteData(
        state.driverLocation!.latitude,
        state.driverLocation!.longitude,
        state.userLocation!.latitude,
        state.userLocation!.longitude,
      );

      if (routeData != null) {
        emit(state.copyWith(
          eta: routeData.eta,
          routePoints: routeData.points,
        ));
      }
    } catch (e) {
      // Handle silently
    }
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    _driverTimer?.cancel();
    _osrmTimer?.cancel();
    return super.close();
  }
}
