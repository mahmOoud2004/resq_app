import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:resq_app/features/driver_emergency/data/models/driver_request_model.dart';
import 'package:resq_app/features/driver_emergency/presentation/cubit/driver_emergency_cubit.dart';
import 'package:resq_app/features/home/presentation/widgets_driver/DriverMapScreen.dart';
import 'package:resq_app/features/navigation/presentation/screen/driver_main_screens.dart';

class NavigationPage extends StatelessWidget {
  final DriverRequestModel request;

  const NavigationPage({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DriverEmergencyCubit>();

    return Scaffold(
      backgroundColor: const Color(0xFF07142A),

      body: Stack(
        children: [
          /// 🗺 MAP (بتاعة السواق)
          Positioned.fill(
            child: DriverMapScreen(
              userLat: request.latitude,
              userLng: request.longitude,
            ),
          ),

          /// 🔥 TOP CARD (User Info)
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF081A33),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.userName ?? "User",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          request.userPhone ?? "",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      // ممكن تضيف اتصال هنا
                    },
                    icon: const Icon(Icons.call, color: Colors.green),
                  ),
                ],
              ),
            ),
          ),

          /// 🔥 BUTTON
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF081A33),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B6EF6),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () async {
                  await cubit.complete(request.id);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const DriverMainScreen()),
                    (route) => false,
                  );
                },
                child: const Text("Arrived"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
