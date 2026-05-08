import 'package:flutter/material.dart';
import 'package:resq_app/core/constants/app_color.dart';

class EmergencyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool hasSelection;

  const EmergencyButton({
    super.key,
    required this.onPressed,
    required this.hasSelection,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,

      child: Container(
        width: 220,
        height: 220,

        decoration: BoxDecoration(
          shape: BoxShape.circle,

          gradient: const LinearGradient(
            colors: [AppColors.primaryLight, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),

          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: .45),
              blurRadius: 40,
              spreadRadius: 5,
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Icon(Icons.health_and_safety, color: Colors.white, size: 40),

            const SizedBox(height: 10),

            Text(
              hasSelection ? "REQUEST NOW" : "REQUEST HELP",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Press for emergency",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
