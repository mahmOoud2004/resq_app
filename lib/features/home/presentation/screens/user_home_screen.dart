import 'dart:async';
import 'package:resq_app/core/theme/theme_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/core/constants/app_color.dart';
import 'package:resq_app/features/emergency/presentation/bloc/emergency_bloc.dart';
import 'package:resq_app/features/home/presentation/widgets_user/emergency_button.dart';
import 'package:resq_app/features/home/presentation/widgets_user/home_header.dart';
import 'package:resq_app/features/home/presentation/widgets_user/location_card.dart';
import 'package:resq_app/features/home/presentation/widgets_user/active_request_card.dart';
import 'package:resq_app/features/home/presentation/widgets_user/emergency_options_grid.dart';
import 'package:resq_app/features/map/services/location_service.dart';
import 'package:resq_app/features/smart_ai_assistant/presentation/widgets/smart_assistant_entry_card.dart';

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

  Timer? timer;

  @override
  void initState() {
    super.initState();
    _loadLocation();

    final bloc = context.read<EmergencyBloc>();

    bloc.add(GetActiveRequestEvent());

    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      bloc.add(GetActiveRequestEvent());
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _loadLocation() async {
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
  }

  void toggleService(String service) {
    setState(() {
      selectedServices.contains(service)
          ? selectedServices.remove(service)
          : selectedServices.add(service);
    });
  }

  void onEmergencyPressed() {
    if (!showEmergencyOptions) {
      setState(() => showEmergencyOptions = true);
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
      child: Scaffold(
        backgroundColor: context.backgroundColor,

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeHeader(),
                const SmartAssistantEntryCard(),
                const SizedBox(height: 8),

                LocationCard(address: address),
                const SizedBox(height: 20),

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
                          selected: selectedServices,
                          onSelect: toggleService,
                        )
                      : const SizedBox(),
                ),

                const SizedBox(height: 30),

                /// 🔥 الكارت
                BlocBuilder<EmergencyBloc, EmergencyState>(
                  builder: (context, state) {
                    if (state is EmergencyLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is EmergencyHasActiveRequest) {
                      return Column(
                        children: [
                          ActiveRequestCard(request: state.request),
                          const SizedBox(height: 40),
                        ],
                      );
                    }

                    /// 🔥 حالة انتهاء الطلب
                    if (state is EmergencyCompleted) {
                      return Column(
                        children: const [
                          Text(
                            "Trip completed successfully",
                            style: TextStyle(
                              color: AppColors.success,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 40),
                        ],
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
