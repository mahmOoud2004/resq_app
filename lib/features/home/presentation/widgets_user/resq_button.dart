import 'package:flutter/material.dart';
import 'package:resq_app/core/constants/app_color.dart';

class ResqButton extends StatelessWidget {
  const ResqButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryLight, AppColors.primaryDark],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.32),
              blurRadius: 32,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medical_services, color: Colors.white, size: 40),

            SizedBox(height: 10),

            Text(
              "RESQ NOW",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 5),

            Text(
              "Press for emergency",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
