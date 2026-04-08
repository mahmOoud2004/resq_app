import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:resq_app/features/home/presentation/screens/driver_home_screen.dart';
import 'package:resq_app/features/driver_emergency/presentation/cubit/driver_emergency_cubit.dart';
import 'package:resq_app/features/navigation/presentation/screen/driver_main_screens.dart';

class NavigationPage extends StatelessWidget {
  final int requestId;

  const NavigationPage({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DriverEmergencyCubit>();

    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                "https://i.imgur.com/2Y3YH7G.png",
                fit: BoxFit.cover,
              ),
            ),

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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B6EF6),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () async {
                          await cubit.complete(requestId);

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DriverMainScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text(
                          "Arrived at Location",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
