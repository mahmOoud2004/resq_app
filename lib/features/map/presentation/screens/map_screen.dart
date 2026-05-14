import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resq_app/core/constants/app_color.dart';
import 'package:resq_app/core/error/app_logger.dart';
import 'package:resq_app/core/error/error_handler.dart';
import 'package:resq_app/core/network/api_constants.dart';
import 'package:resq_app/core/theme/theme_ext.dart';
import 'package:resq_app/features/emergency/presentation/bloc/emergency_bloc.dart';
import 'package:resq_app/features/map/presentation/cubit/tracking_cubit.dart';
import 'package:resq_app/features/map/presentation/cubit/tracking_state.dart';
import 'package:resq_app/features/map/presentation/widgets/driver_bottom_card.dart';
import 'package:resq_app/features/map/services/location_service.dart';

class MapScreen extends StatelessWidget {
  final double? lat;
  final double? lng;

  const MapScreen({
    super.key,
    this.lat,
    this.lng,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TrackingCubit(LocationService()),
      child: _MapScreenBody(
        lat: lat,
        lng: lng,
      ),
    );
  }
}

class _MapScreenBody extends StatefulWidget {
  final double? lat;
  final double? lng;

  const _MapScreenBody({
    this.lat,
    this.lng,
  });

  @override
  State<_MapScreenBody> createState() => _MapScreenBodyState();
}

class _MapScreenBodyState extends State<_MapScreenBody> {
  GoogleMapController? _mapController;
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  bool isViewingDriver = false;
  bool _loadingHospitals = false;
  int? _trackedRequestId;
  Set<Marker> hospitalMarkers = {};

  @override
  void initState() {
    super.initState();
    context.read<EmergencyBloc>().add(GetActiveRequestEvent());
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _loadNearbyHospitals(LatLng userLocation) async {
    if (_loadingHospitals || hospitalMarkers.isNotEmpty) {
      return;
    }

    final apiKey = dotenv.env[ApiConstants.googleMapsApiKeyEnv]?.trim();
    if (apiKey == null || apiKey.isEmpty) {
      AppLogger.warning(
        'Google Maps API key is missing. Skipping nearby hospitals.',
        name: 'MapScreen',
      );
      return;
    }

    _loadingHospitals = true;
    try {
      final url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
          "?location=${userLocation.latitude},${userLocation.longitude}"
          "&radius=5000"
          "&type=hospital"
          "&key=$apiKey";

      final response = await dio.get(url);
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const FormatException('Hospitals response is invalid.');
      }

      final results = data["results"];
      if (results is! List) {
        return;
      }

      final hospitals = <Marker>{};
      for (final hospital in results) {
        if (hospital is! Map) continue;
        final geometry = hospital["geometry"];
        final location = geometry is Map ? geometry["location"] : null;
        final name = hospital["name"]?.toString() ?? "Hospital";
        final lat = double.tryParse(location?["lat"]?.toString() ?? '');
        final lng = double.tryParse(location?["lng"]?.toString() ?? '');
        if (lat == null || lng == null) continue;

        hospitals.add(
          Marker(
            markerId: MarkerId(name),
            position: LatLng(lat, lng),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
            infoWindow: InfoWindow(title: name),
          ),
        );
      }

      if (!mounted) return;
      setState(() {
        hospitalMarkers = hospitals;
      });
    } catch (error, stackTrace) {
      final appException = ErrorHandler.handle(error, stackTrace: stackTrace);
      AppLogger.error(
        'Failed to load nearby hospitals.',
        name: 'MapScreen',
        error: error,
        stackTrace: stackTrace,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(appException.userMessage)),
        );
      }
    } finally {
      _loadingHospitals = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmergencyBloc, EmergencyState>(
      builder: (context, emergencyState) {
        String? driverName;
        String? driverPhone;
        String? status;

        if (emergencyState is EmergencyHasActiveRequest) {
          driverName = emergencyState.request.driverName;
          driverPhone = emergencyState.request.driverPhone;
          status = emergencyState.request.status;

          if (_trackedRequestId != emergencyState.request.id) {
            _trackedRequestId = emergencyState.request.id;
            context.read<TrackingCubit>().startTrackingDriver(
                  emergencyState.request.id,
                );
          }
        }

        return BlocConsumer<TrackingCubit, TrackingState>(
          listener: (context, trackingState) {
            if (trackingState.userLocation != null && hospitalMarkers.isEmpty) {
              _loadNearbyHospitals(trackingState.userLocation!);
            }

            if (trackingState.error != null && trackingState.error!.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(trackingState.error!)),
              );
            }
          },
          builder: (context, trackingState) {
            return _buildMap(
              context,
              trackingState,
              driverName,
              driverPhone,
              status,
            );
          },
        );
      },
    );
  }

  Widget _buildMap(
    BuildContext context,
    TrackingState state,
    String? driverName,
    String? driverPhone,
    String? status,
  ) {
    if (state.isLoading || state.userLocation == null) {
      return Scaffold(
        backgroundColor: context.backgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final showDriverCard = status == "accepted" || status == "on_way";
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('user_location'),
        position: state.userLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Your Location'),
      ),
      ...hospitalMarkers,
    };

    if (state.driverLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('driver_location'),
          position: state.driverLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Ambulance'),
        ),
      );
    }

    final polylines = <Polyline>{};
    if (state.routePoints.isNotEmpty) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: state.routePoints,
          color: AppColors.primary,
          width: 5,
        ),
      );
    }

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: state.userLocation!,
              zoom: 14,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: markers,
            polylines: polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          Positioned(
            bottom: 120,
            right: 20,
            child: FloatingActionButton(
              backgroundColor:
                  isViewingDriver ? AppColors.primary : AppColors.accent,
              onPressed: () {
                if (state.driverLocation == null) return;

                setState(() {
                  isViewingDriver = !isViewingDriver;
                });

                _mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    isViewingDriver ? state.driverLocation! : state.userLocation!,
                    15,
                  ),
                );
              },
              child: Icon(
                isViewingDriver ? Icons.person : Icons.local_taxi,
                color: Colors.white,
              ),
            ),
          ),
          if (showDriverCard)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: DriverBottomCard(
                name: driverName,
                phone: driverPhone,
                eta: state.eta,
              ),
            ),
        ],
      ),
    );
  }
}
