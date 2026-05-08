import 'package:resq_app/core/theme/theme_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resq_app/core/constants/app_color.dart';
import 'package:resq_app/features/emergency/presentation/bloc/emergency_bloc.dart';
import 'package:resq_app/features/map/presentation/cubit/tracking_cubit.dart';
import 'package:resq_app/features/map/presentation/cubit/tracking_state.dart';
import 'package:resq_app/features/map/presentation/widgets/driver_bottom_card.dart';
import 'package:resq_app/features/map/services/location_service.dart';

class MapScreen extends StatelessWidget {
  final double? lat;
  final double? lng;

  const MapScreen({super.key, this.lat, this.lng});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TrackingCubit(LocationService()),
      child: _MapScreenBody(lat: lat, lng: lng),
    );
  }
}

class _MapScreenBody extends StatefulWidget {
  final double? lat;
  final double? lng;

  const _MapScreenBody({this.lat, this.lng});

  @override
  State<_MapScreenBody> createState() => _MapScreenBodyState();
}

class _MapScreenBodyState extends State<_MapScreenBody> {
  GoogleMapController? _mapController;
  bool isViewingDriver = false;

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

          context.read<TrackingCubit>().startTrackingDriver(emergencyState.request.id);
        }

        return BlocBuilder<TrackingCubit, TrackingState>(
          builder: (context, trackingState) {
            return _buildMap(context, trackingState, driverName, driverPhone, status);
          },
        );
      },
    );
  }

  Widget _buildMap(BuildContext context, TrackingState state, String? driverName, String? driverPhone, String? status) {
    if (state.isLoading || state.userLocation == null) {
      return Scaffold(
        backgroundColor: context.backgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    bool showDriverCard = status == "accepted" || status == "on_way";

    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('user_location'),
        position: state.userLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Your Location'),
      ),
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

    Set<Polyline> polylines = {};
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
              zoom: 15,
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
              backgroundColor: isViewingDriver ? AppColors.primary : AppColors.accent,
              onPressed: () {
                if (state.driverLocation == null) return;
                setState(() {
                  isViewingDriver = !isViewingDriver;
                });
                if (isViewingDriver) {
                  _mapController?.animateCamera(CameraUpdate.newLatLngZoom(state.driverLocation!, 15));
                } else {
                  _mapController?.animateCamera(CameraUpdate.newLatLngZoom(state.userLocation!, 15));
                }
              },
              child: Icon(isViewingDriver ? Icons.person : Icons.local_taxi, color: Colors.white),
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
