import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            const CircleAvatar(
              radius: 45,
              backgroundColor: Color(0xFF2563EB),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage("assets/images/avatar.png"),
              ),
            ),

            Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF07142A), width: 2),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        const Text(
          "5ARBOSH ELSHAY",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        const Text(
          "5ARBOOSH.ELSHAY@TEA.com",
          style: TextStyle(color: Colors.white54, fontSize: 14),
        ),
      ],
    );
  }
}
