import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/features/driver_emergency/presentation/cubit/driver_emergency_cubit.dart';

class DriverStatusCard extends StatefulWidget {
  const DriverStatusCard({super.key});

  @override
  State<DriverStatusCard> createState() => _DriverStatusCardState();
}

class _DriverStatusCardState extends State<DriverStatusCard> {
  bool isOnline = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14273F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          /// 🔥 Status Icon
          Icon(
            Icons.circle,
            size: 12,
            color: isOnline ? Colors.green : Colors.red,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Driver Status",
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  isOnline ? "Available for requests" : "Offline",
                  style: TextStyle(
                    color: isOnline ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          /// 🔥 Switch
          Switch(
            value: isOnline,
            activeColor: Colors.green,
            onChanged: (value) {
              setState(() => isOnline = value);

              if (value) {
                context.read<DriverEmergencyCubit>().loadRequests();
              }
            },
          ),
        ],
      ),
    );
  }
}
