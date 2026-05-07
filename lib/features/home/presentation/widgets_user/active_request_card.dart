import 'package:flutter/material.dart';
import 'package:resq_app/features/emergency/data/model/active_request_mode.dart';
import 'package:resq_app/features/home/presentation/widgets_user/track_driver_screen.dart';

class ActiveRequestCard extends StatelessWidget {
  final ActiveRequestModel request;

  const ActiveRequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2E5BFF), width: 1),
        color: const Color(0xFF0F2347),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _statusColor(request.status),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                request.status.toUpperCase(),
                style: TextStyle(color: _statusColor(request.status)),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF2E6BFF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_taxi, color: Colors.white),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.driverName ?? "Searching for driver...",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      request.driverPhone ?? "",
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
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
              },
              child: const Text("Track Driver"),
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
        return Colors.blue;
      case "on_way":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
