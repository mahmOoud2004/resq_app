import 'package:flutter/material.dart';
import 'package:resq_app/core/theme/theme_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/core/constants/app_color.dart';
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
        color: context.surfaceLightColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
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
                Text(
                  "Driver Status",
                  style: TextStyle(color: context.textSecondaryColor),
                ),
                Text(
                  isOnline ? "Available for requests" : "Offline",
                  style: TextStyle(
                    color: isOnline ? AppColors.success : AppColors.danger,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          /// 🔥 Switch
          Switch(
            value: isOnline,
            activeThumbColor: AppColors.success,
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
