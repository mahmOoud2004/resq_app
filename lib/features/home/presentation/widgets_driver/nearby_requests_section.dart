import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/core/constants/app_color.dart';
import 'package:resq_app/core/theme/theme_ext.dart';

import 'package:resq_app/features/driver_emergency/presentation/cubit/driver_emergency_cubit.dart';
import 'package:resq_app/features/driver_emergency/presentation/cubit/driver_emergency_state.dart';

import 'request_card.dart';

class NearbyRequestsSection extends StatelessWidget {
  const NearbyRequestsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Nearby Requests",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<DriverEmergencyCubit, DriverEmergencyState>(
              builder: (context, state) {
                if (!state.isOnline) {
                  return Center(
                    child: Text(
                      "You are offline.\nTurn on Driver Status to receive requests.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: context.textSecondaryColor),
                    ),
                  );
                }

                if (state is DriverEmergencyLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is DriverEmergencyLoaded) {
                  if (state.requests.isEmpty) {
                    return Center(
                      child: Text(
                        "No Requests Available",
                        style: TextStyle(color: context.textSecondaryColor),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: state.requests.length,
                    itemBuilder: (context, index) {
                      final request = state.requests[index];

                      return RequestCard(
                        request: request,
                        title: request.serviceType,
                        distance: "${request.latitude}, ${request.longitude}",
                        location: "Emergency Location",
                      );
                    },
                  );
                }

                if (state is DriverEmergencyError) {
                  return Center(
                    child: Text(
                      state.message ?? "Failed to load requests",
                      style: const TextStyle(color: AppColors.danger),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
