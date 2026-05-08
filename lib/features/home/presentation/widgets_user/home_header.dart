import 'package:flutter/material.dart';
import 'package:resq_app/core/theme/theme_ext.dart';
import 'package:resq_app/core/constants/app_color.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.local_hospital, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            const Text(
              "ResQ",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),

        IconButton(
          onPressed: () {},
          style: IconButton.styleFrom(
            backgroundColor: context.surfaceLightColor,
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }
}
