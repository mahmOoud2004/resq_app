import 'package:flutter/material.dart';
import 'package:resq_app/core/constants/app_color.dart';

class DispatchButton extends StatelessWidget {
  final VoidCallback onTap;

  const DispatchButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryLight, AppColors.primaryDark],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.28),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.radar, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Send Emergency Request",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
