import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resq_app/core/error/app_logger.dart';
import 'package:resq_app/core/error/error_handler.dart';
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
  bool _fetchingDriverLocation = false;
  bool _fetchingRoute = false;

  TrackingCubit(this._locationService) : super(const TrackingState()) {
    _initUserLocation();
  }

  Future<void> _initUserLocation() async {
    try {
      final position = await _locationService.getCurrentLocation();
      final userLocation = LatLng(position.latitude, position.longitude);

      emit(
        state.copyWith(
          userLocation: userLocation,
          isLoading: false,
          error: null,
        ),
      );

      _locationSubscription = _locationService.getLocationStream().listen(
        (position) {
          emit(
            state.copyWith(
              userLocation: LatLng(position.latitude, position.longitude),
              error: null,
            ),
          );
        },
        onError: (error, stackTrace) {
          final appException = ErrorHandler.handle(error);
          AppLogger.error(
            'Location stream failed.',
            name: 'TrackingCubit',
            error: error,
            stackTrace: stackTrace is StackTrace ? stackTrace : null,
          );
          emit(
            state.copyWith(
              error: appException.userMessage,
            ),
          );
        },
      );
    } catch (error, stackTrace) {
      final appException = ErrorHandler.handle(error, stackTrace: stackTrace);
      AppLogger.error(
        'Initial location fetch failed.',
        name: 'TrackingCubit',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          isLoading: false,
          error: appException.userMessage,
        ),
      );
    }
  }

  void startTrackingDriver(int requestId) {
    if (currentRequestId == requestId) return;

    currentRequestId = requestId;
    _driverTimer?.cancel();
    _routeTimer?.cancel();

    unawaited(_fetchDriverLocation());
    unawaited(_fetchRouteAndEta());

    _driverTimer = Timer.periodic(
      const Duration(seconds: 8),
      (_) => unawaited(_fetchDriverLocation()),
    );

    _routeTimer = Timer.periodic(
      const Duration(seconds: 20),
      (_) => unawaited(_fetchRouteAndEta()),
    );
  }

  Future<void> _fetchDriverLocation() async {
    if (currentRequestId == null || _fetchingDriverLocation) return;
    _fetchingDriverLocation = true;

    try {
      final response = await dio.get("/emergency/track-driver/$currentRequestId");
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const FormatException('Track driver response is invalid.');
      }

      final driver = data["driver_location"];
      if (driver is! Map<String, dynamic>) {
        return;
      }

      double lat = double.tryParse(driver["lat"].toString()) ?? 0;
      double lng = double.tryParse(driver["lng"].toString()) ?? 0;

      if (state.userLocation != null &&
          lat == state.userLocation!.latitude &&
          lng == state.userLocation!.longitude) {
        lat += 0.0007;
        lng += 0.0007;
      }

      emit(
        state.copyWith(
          driverLocation: LatLng(lat, lng),
          error: null,
        ),
      );
    } catch (error, stackTrace) {
      final appException = ErrorHandler.handle(error, stackTrace: stackTrace);
      AppLogger.error(
        'Driver tracking failed.',
        name: 'TrackingCubit',
        error: error,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(error: appException.userMessage));
    } finally {
      _fetchingDriverLocation = false;
    }
  }

  Future<void> _fetchRouteAndEta() async {
    if (state.driverLocation == null ||
        state.userLocation == null ||
        _fetchingRoute) {
      return;
    }

    _fetchingRoute = true;

    try {
      final routeData = await _locationService.getRouteData(
        state.driverLocation!.latitude,
        state.driverLocation!.longitude,
        state.userLocation!.latitude,
        state.userLocation!.longitude,
      );

      if (routeData != null) {
        emit(
          state.copyWith(
            eta: routeData.eta,
            routePoints: routeData.points,
            error: null,
          ),
        );
      }
    } catch (error, stackTrace) {
      final appException = ErrorHandler.handle(error, stackTrace: stackTrace);
      AppLogger.error(
        'Route fetch failed.',
        name: 'TrackingCubit',
        error: error,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(error: appException.userMessage));
    } finally {
      _fetchingRoute = false;
    }
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    _driverTimer?.cancel();
    _routeTimer?.cancel();
    return super.close();
  }
}
