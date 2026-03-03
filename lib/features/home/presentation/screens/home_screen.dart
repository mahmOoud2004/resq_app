import 'package:flutter/material.dart';
import 'package:resq_app/core/constants/app_color.dart';
import 'package:resq_app/features/home/presentation/widgets/bottom_nav_bar.dart';
import '../widgets/service_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),

              /// Greeting
              const Text(
                "Hello, mahmoud !",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 20),

              /// Services
              Expanded(
                child: ListView(
                  children: const [
                    ServiceCard(
                      title: "Ambulance",
                      image: "assets/images/ambulance.png",
                    ),
                    SizedBox(height: 15),
                    ServiceCard(
                      title: "Fire Truck",
                      image: "assets/images/fire_truck.png",
                    ),
                    SizedBox(height: 15),
                    ServiceCard(
                      title: "Tow Truck",
                      image: "assets/images/tow_truck.png",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      /// Bottom Nav
      bottomNavigationBar: const HomeBottomNav(),
    );
  }
}
