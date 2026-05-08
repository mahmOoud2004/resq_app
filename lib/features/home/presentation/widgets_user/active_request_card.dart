import 'package:flutter/material.dart';
import 'package:resq_app/core/constants/app_color.dart';
import 'package:resq_app/features/emergency/data/model/active_request_mode.dart';
import 'package:resq_app/features/home/presentation/widgets_user/track_driver_screen.dart';

class ActiveRequestCard extends StatelessWidget {
  final ActiveRequestModel request;

  const ActiveRequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final bool canTrack =
        request.status == "accepted" || request.status == "on_way";

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.7)),
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _statusColor(request.status),
                  shape: BoxShape.circle,
                ),
              ),

              const SizedBox(width: 8),

              Text(
                _statusText(request.status),
                style: TextStyle(
                  color: _statusColor(request.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_taxi, color: Colors.white),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.driverName ?? "Searching for driver...",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      request.driverPhone ?? "Waiting for driver details",
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton.icon(
              onPressed: canTrack
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TrackDriverScreen(
                            requestId: request.id,
                            userLat: request.lat,
                            userLng: request.lng,
                          ),
                        ),
                      );
                    }
                  : null,

              icon: const Icon(Icons.navigation),

              label: const Text(
                "Track Driver",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange;

      case "accepted":
        return AppColors.accent;

      case "on_way":
        return AppColors.success;

      default:
        return Colors.grey;
    }
  }

  String _statusText(String status) {
    switch (status) {
      case "pending":
        return "SEARCHING";

      case "accepted":
        return "DRIVER ACCEPTED";

      case "on_way":
        return "ON THE WAY";

      default:
        return status.toUpperCase();
    }
  }
}
