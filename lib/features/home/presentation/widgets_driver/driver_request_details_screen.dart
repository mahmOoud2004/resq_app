import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:resq_app/features/home/presentation/screens/driver_home_screen.dart';
import 'package:resq_app/features/home/presentation/widgets_driver/navigation_page.dart';

import 'package:resq_app/features/driver_emergency/presentation/cubit/driver_emergency_cubit.dart';

class DriverRequestDetailsScreen extends StatelessWidget {
  final int requestId;

  const DriverRequestDetailsScreen({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081A33),

      appBar: AppBar(
        backgroundColor: const Color(0xFF081A33),
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          "New Emergency Request",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            /// Emergency Location
            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: const Color(0xFF0F2747),
                borderRadius: BorderRadius.circular(16),
              ),

              child: Row(
                children: const [
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.location_on, color: Colors.white),
                  ),

                  SizedBox(width: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Emergency Location",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),

                      SizedBox(height: 4),

                      Text(
                        "User Location",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Request Details
            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: const Color(0xFF0F2747),
                borderRadius: BorderRadius.circular(16),
              ),

              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Emergency Request",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "A user has requested emergency assistance.",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// Buttons
            Row(
              children: [
                /// Reject
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.white30),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    onPressed: () async {
                      await context.read<DriverEmergencyCubit>().cancel(
                        requestId,
                      );

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: context.read<DriverEmergencyCubit>(),
                            child: const DriverHomeScreen(),
                          ),
                        ),
                        (route) => false,
                      );
                    },

                    child: const Text(
                      "Reject",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                /// Accept
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,

                      padding: const EdgeInsets.symmetric(vertical: 16),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    onPressed: () async {
                      final cubit = context.read<DriverEmergencyCubit>();

                      await cubit.accept(requestId);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<DriverEmergencyCubit>(),
                            child: NavigationPage(requestId: requestId),
                          ),
                        ),
                      );
                    },

                    child: const Text(
                      "Accept Request",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
