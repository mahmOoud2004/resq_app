import 'package:flutter/material.dart';
import 'package:resq_app/core/constants/app_color.dart';

class UserLocationMarker extends StatelessWidget {
  const UserLocationMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: const Icon(Icons.my_location, color: Colors.white, size: 30),
    );
  }
}
