import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingState extends Equatable {
  final LatLng? userLocation;
  final LatLng? driverLocation;
  final String? eta;
  final List<LatLng> routePoints;
  final bool isLoading;
  final String? error;

  const TrackingState({
    this.userLocation,
    this.driverLocation,
    this.eta,
    this.routePoints = const [],
    this.isLoading = true,
    this.error,
  });

  TrackingState copyWith({
    LatLng? userLocation,
    LatLng? driverLocation,
    String? eta,
    List<LatLng>? routePoints,
    bool? isLoading,
    String? error,
  }) {
    return TrackingState(
      userLocation: userLocation ?? this.userLocation,
      driverLocation: driverLocation ?? this.driverLocation,
      eta: eta ?? this.eta,
      routePoints: routePoints ?? this.routePoints,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [userLocation, driverLocation, eta, routePoints, isLoading, error];
}
