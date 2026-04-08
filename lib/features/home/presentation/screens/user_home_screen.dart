import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/features/emergency/presentation/bloc/emergency_bloc.dart';
import 'package:resq_app/features/home/presentation/widgets_user/emergency_button.dart';
import 'package:resq_app/features/home/presentation/widgets_user/home_header.dart';
import 'package:resq_app/features/home/presentation/widgets_user/location_card.dart';
import 'package:resq_app/features/home/presentation/widgets_user/active_request_card.dart';
import 'package:resq_app/features/home/presentation/widgets_user/emergency_options_grid.dart';

import 'package:resq_app/features/map/services/location_service.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final LocationService _locationService = LocationService();

  bool showEmergencyOptions = false;

  List<String> selectedServices = [];

  String address = "Detecting location...";
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    try {
      final position = await _locationService.getCurrentLocation();

      final addr = await _locationService.getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        address = addr;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void toggleService(String service) {
    setState(() {
      if (selectedServices.contains(service)) {
        selectedServices.remove(service);
      } else {
        selectedServices.add(service);
      }
    });
  }

  void onEmergencyPressed() {
    if (!showEmergencyOptions) {
      setState(() {
        showEmergencyOptions = true;
      });
      return;
    }

    if (selectedServices.isNotEmpty && latitude != null && longitude != null) {
      for (var service in selectedServices) {
        context.read<EmergencyBloc>().add(
          SendEmergencyEvent(
            serviceType: service,
            lat: latitude!,
            lng: longitude!,
          ),
        );
      }

      setState(() {
        selectedServices.clear();
        showEmergencyOptions = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(color: Color(0xFF07142A)),

        child: Scaffold(
          backgroundColor: Colors.transparent,

          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const HomeHeader(),

                  const SizedBox(height: 20),

                  LocationCard(address: address),

                  const SizedBox(height: 20),

                  // if (latitude != null && longitude != null)
                  //   SizedBox(
                  //     height: 220,
                  //     child: ClipRRect(
                  //       borderRadius: BorderRadius.circular(16),
                  //       child: MapScreen(lat: latitude!, lng: longitude!),
                  //     ),
                  //   )
                  // else
                  //   const Center(child: CircularProgressIndicator()),

                  // const SizedBox(height: 40),
                  Center(
                    child: EmergencyButton(
                      onPressed: onEmergencyPressed,
                      hasSelection: selectedServices.isNotEmpty,
                    ),
                  ),

                  const SizedBox(height: 30),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),

                    child: showEmergencyOptions
                        ? EmergencyOptionsGrid(
                            key: const ValueKey(1),
                            selected: selectedServices,
                            onSelect: toggleService,
                          )
                        : const SizedBox(),
                  ),

                  const SizedBox(height: 40),

                  BlocBuilder<EmergencyBloc, EmergencyState>(
                    builder: (context, state) {
                      if (state is EmergencyLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is EmergencyActive) {
                        return const ActiveRequestCard();
                      }

                      return const SizedBox();
                    },
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
