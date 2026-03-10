import 'package:flutter/material.dart';
import 'package:resq_app/features/home/presentation/widgets/emergency_button.dart';
import 'package:resq_app/features/home/presentation/widgets/home_header.dart';
import 'package:resq_app/features/home/presentation/widgets/location_card.dart';
import 'package:resq_app/features/home/presentation/widgets/active_request_card.dart';
import 'package:resq_app/features/home/presentation/widgets/emergency_options_grid.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  bool showEmergencyOptions = false;

  void onEmergencyPressed() {
    setState(() {
      showEmergencyOptions = !showEmergencyOptions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(color: Color(0xFF07142A)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeHeader(),

                  SizedBox(height: 20),

                  LocationCard(),

                  SizedBox(height: 40),

                  Center(child: EmergencyButton(onPressed: onEmergencyPressed)),

                  const SizedBox(height: 30),

                  if (showEmergencyOptions) const EmergencyOptionsGrid(),

                  const SizedBox(height: 40),

                  const ActiveRequestCard(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
