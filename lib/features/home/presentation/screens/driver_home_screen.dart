import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/core/theme/theme_ext.dart';

import 'package:resq_app/features/driver_emergency/presentation/cubit/driver_emergency_cubit.dart';
import 'package:resq_app/features/driver_emergency/presentation/cubit/driver_emergency_state.dart';
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
        backgroundColor: context.backgroundColor,
        appBar: AppBar(
          backgroundColor: context.backgroundColor,
          elevation: 0,
          title: const Text(
            "ResQ Driver",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<DriverEmergencyCubit, DriverEmergencyState>(
            builder: (context, state) {
              return Column(
                children: [
                  const DriverStatusCard(),
                  const SizedBox(height: 16),
                  if (!state.isOnline)
                    Expanded(
                      child: Center(
                        child: Text(
                          "Driver mode is offline.\nNo requests can be accepted right now.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: context.textSecondaryColor,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ),
                    )
                  else ...const [
                    DriverMapCard(),
                    SizedBox(height: 20),
                    NearbyRequestsSection(),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
