import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                if (state is DriverEmergencyLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is DriverEmergencyLoaded) {
                  if (state.requests.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Requests Available",
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: state.requests.length,
                    itemBuilder: (context, index) {
                      final request = state.requests[index];

                      return RequestCard(
                        requestId: request.id,
                        title: request.serviceType,
                        distance: "${request.latitude}, ${request.longitude}",
                        location: "Emergency Location",
                      );
                    },
                  );
                }

                if (state is DriverEmergencyError) {
                  return const Center(
                    child: Text(
                      "Failed to load requests",
                      style: TextStyle(color: Colors.red),
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
