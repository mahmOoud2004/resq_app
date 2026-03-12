import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/features/emergency/presentation/bloc/emergency_bloc.dart';
import 'package:resq_app/features/home/presentation/widgets/emergency_button.dart';
import 'package:resq_app/features/home/presentation/widgets/home_header.dart';
import 'package:resq_app/features/home/presentation/widgets/location_card.dart';
import 'package:resq_app/features/home/presentation/widgets/active_request_card.dart';
import 'package:resq_app/features/home/presentation/widgets/emergency_options_grid.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  bool showEmergencyOptions = false;
  bool hasActiveRequest = false;

  List<String> selectedServices = [];

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

    if (selectedServices.isNotEmpty) {
      for (var service in selectedServices) {
        context.read<EmergencyBloc>().add(
          SendEmergencyEvent(
            serviceType: service,
            lat: 30.044420,
            lng: 31.235712,
          ),
        );
      }

      setState(() {
        hasActiveRequest = true;
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

                  const LocationCard(),

                  const SizedBox(height: 40),

                  Center(
                    child: EmergencyButton(
                      onPressed: onEmergencyPressed,
                      hasSelection: selectedServices.isNotEmpty,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Animation للكروت
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, .3),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: showEmergencyOptions
                        ? EmergencyOptionsGrid(
                            key: const ValueKey(1),
                            selected: selectedServices,
                            onSelect: toggleService,
                          )
                        : const SizedBox(),
                  ),

                  const SizedBox(height: 40),

                  if (hasActiveRequest) const ActiveRequestCard(),

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
