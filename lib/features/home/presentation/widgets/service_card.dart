import 'package:flutter/material.dart';
import 'package:resq_app/core/constants/app_color.dart';

class ServiceCard extends StatelessWidget {
  final String title;
  final String image;

  const ServiceCard({super.key, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradient1, AppColors.gradient2],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          /// Title
          Align(
            alignment: Alignment.topRight,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          /// Image
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(image, height: 200),
          ),
        ],
      ),
    );
  }
}
