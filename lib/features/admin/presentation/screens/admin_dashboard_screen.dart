import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:resq_app/core/constants/app_color.dart';
import 'package:resq_app/core/theme/theme_ext.dart';

import '../bloc/admin_bloc.dart';
import '../bloc/admin_event.dart';
import '../bloc/admin_state.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: BlocBuilder<AdminBloc, AdminState>(
            builder: (context, state) {
              if (state is AdminLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is AdminDashboardLoaded) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<AdminBloc>().add(LoadDashboard());
                  },

                  child: ListView(
                    children: [
                      const Text(
                        "Admin Home",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),

                      const SizedBox(height: 20),

                      /// GRID
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.8,

                        children: [
                          _statCard(
                            state.stats.totalUsers.toString(),
                            "Users",
                            Icons.people,
                            context,
                          ),

                          _statCard(
                            state.stats.totalDrivers.toString(),
                            "Drivers",
                            Icons.drive_eta,
                            context,
                          ),

                          _statCard(
                            state.stats.pendingUsers.toString(),
                            "Pending",
                            Icons.hourglass_bottom,
                            context,
                          ),

                          _statCard(
                            state.stats.activeEmergencies.toString(),
                            "Active",
                            Icons.warning,
                            context,
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      /// HEADER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Text(
                            "Live Requests",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),

                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: Text(
                              "${state.emergencies.length} Active",

                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      ...state.emergencies.map(
                        (e) => _RequestCard(
                          id: e.id,
                          name: e.userName,
                          phone: e.phone,
                          driver: e.driverName ?? "No Driver",
                          service: e.serviceType,
                          status: e.status,
                          lat: e.latitude,
                          lng: e.longitude,
                          date: e.createdAt,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (state is AdminError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _statCard(
    String number,
    String title,
    IconData icon,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.borderColor),
      ),

      child: Row(
        children: [
          Icon(icon, color: AppColors.accent, size: 26),

          const SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Text(
                number,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(title, style: const TextStyle(color: Colors.white60)),
            ],
          ),
        ],
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final int id;
  final String name;
  final String phone;
  final String driver;
  final String service;
  final String status;
  final String lat;
  final String lng;
  final String date;

  const _RequestCard({
    required this.id,
    required this.name,
    required this.phone,
    required this.driver,
    required this.service,
    required this.status,
    required this.lat,
    required this.lng,
    required this.date,
  });

  Color getStatusColor(BuildContext context) {
    switch (status.toLowerCase()) {
      case "waiting":
        return AppColors.warning;

      case "accepted":
        return AppColors.success;

      case "in_progress":
        return AppColors.accent;

      default:
        return context.textMutedColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getStatusColor(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.borderColor),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// HEADER
          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFF1C335A),

                child: Icon(Icons.person, color: Colors.white),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  name,

                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),

                decoration: BoxDecoration(
                  color: color.withValues(alpha: .18),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Text(
                  status,

                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// SERVICE
          Row(
            children: [
              const Icon(
                Icons.medical_services,
                color: Colors.white54,
                size: 18,
              ),

              const SizedBox(width: 8),

              Text(
                "Service : $service",

                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// PHONE
          Row(
            children: [
              const Icon(Icons.phone, color: Colors.white54, size: 18),

              const SizedBox(width: 8),

              Text(phone, style: const TextStyle(color: Colors.white70)),
            ],
          ),

          const SizedBox(height: 6),

          /// DRIVER
          Row(
            children: [
              const Icon(Icons.drive_eta, color: Colors.white54, size: 18),

              const SizedBox(width: 8),

              Text(
                "Driver : $driver",

                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// LOCATION
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.primary, size: 18),

              const SizedBox(width: 8),

              Text(
                "$lat , $lng",

                style: const TextStyle(color: Colors.white60),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// DATE
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white54, size: 18),

              const SizedBox(width: 8),

              Text(date, style: const TextStyle(color: Colors.white60)),
            ],
          ),

          const SizedBox(height: 14),

          /// CANCEL BUTTON
          SizedBox(
            width: double.infinity,

            child: ElevatedButton.icon(
              icon: const Icon(Icons.cancel),

              label: const Text("Cancel Request"),

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),

              onPressed: () {
                context.read<AdminBloc>().add(CancelEmergencyEvent(id));
              },
            ),
          ),
        ],
      ),
    );
  }
}
