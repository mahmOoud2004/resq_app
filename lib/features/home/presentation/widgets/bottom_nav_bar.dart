import 'package:flutter/material.dart';
import 'package:resq_app/core/constants/app_color.dart';

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gradient1, AppColors.gradient2],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.map, color: Colors.white70),
          Icon(Icons.chat_outlined, color: Colors.white70),
          Icon(Icons.person, color: Colors.white70),
        ],
      ),
    );
  }
}
