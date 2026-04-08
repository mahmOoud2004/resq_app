import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:resq_app/features/driver_emergency/presentation/cubit/driver_emergency_cubit.dart';

import 'package:resq_app/features/home/presentation/widgets_driver/driver_map_card.dart';
import 'package:resq_app/features/home/presentation/widgets_driver/driver_status_card.dart';
import 'package:resq_app/features/home/presentation/widgets_driver/nearby_requests_section.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DriverEmergencyCubit()..loadRequests(),
      child: Scaffold(
        backgroundColor: const Color(0xFF081A2F),
        appBar: AppBar(
          backgroundColor: const Color(0xFF081A2F),
          elevation: 0,
          title: const Text(
            "ResQ Driver",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              DriverStatusCard(),
              SizedBox(height: 16),
              DriverMapCard(),
              SizedBox(height: 20),
              NearbyRequestsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
