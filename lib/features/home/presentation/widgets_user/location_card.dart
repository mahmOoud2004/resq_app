import 'package:flutter/material.dart';
import 'package:resq_app/core/constants/app_color.dart';

class LocationCard extends StatelessWidget {
  final String address;
  final VoidCallback? onChange;

  const LocationCard({super.key, required this.address, this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.location_on, color: AppColors.accent),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Current Location",
                  style: TextStyle(color: AppColors.textSecondary),
                ),

                const SizedBox(height: 2),

                Text(
                  address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          TextButton(
            onPressed: onChange,
            child: const Text(
              "Change",
              style: TextStyle(
                color: AppColors.accentLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
