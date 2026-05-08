import 'package:flutter/material.dart';
import 'package:resq_app/core/theme/theme_ext.dart';
import 'package:resq_app/core/constants/app_color.dart';

class DriverBottomCard extends StatelessWidget {
  final String? name;
  final String? phone;
  final String? eta;

  const DriverBottomCard({super.key, this.name, this.phone, this.eta});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: context.borderColor)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.accent,
            child: Icon(Icons.person, color: Colors.white),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? "Waiting for driver...",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phone ?? "",
                  style: const TextStyle(color: Colors.white54),
                ),
                if (eta != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.timer,
                          color: AppColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          eta!,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call, color: Colors.green),
          ),
        ],
      ),
    );
  }
}
