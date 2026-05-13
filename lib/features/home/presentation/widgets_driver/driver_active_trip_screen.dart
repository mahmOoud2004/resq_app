import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:resq_app/core/theme/theme_ext.dart';

import 'package:resq_app/features/driver_emergency/data/repositories/driver_emergency_repository.dart';
import 'package:resq_app/features/driver_emergency/data/models/driver_request_model.dart';

import 'package:resq_app/features/driver_emergency/presentation/cubit/driver_emergency_cubit.dart';

import 'package:resq_app/features/home/presentation/widgets_driver/navigation_page.dart';

class DriverActiveTripScreen extends StatefulWidget {
  const DriverActiveTripScreen({
    super.key,
  });

  @override
  State<DriverActiveTripScreen> createState() => _DriverActiveTripScreenState();
}

class _DriverActiveTripScreenState extends State<DriverActiveTripScreen> {
  final repository = DriverEmergencyRepository();

  bool isLoading = true;

  DriverRequestModel? request;

  @override
  void initState() {
    super.initState();

    loadActiveTrip();
  }

  Future<void> loadActiveTrip() async {
    try {
      final data = await repository.getActiveRequest();

      request = data;
    } catch (e) {
      debugPrint(
        "ACTIVE TRIP ERROR => $e",
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Current Emergency",
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : request == null
              ? const Center(
                  child: Text(
                    "No Active Emergency",
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(
                    16,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(
                        20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request!.serviceType.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Text(
                            "Patient: ${request!.userName ?? "Unknown"}",
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Phone: ${request!.userPhone ?? "N/A"}",
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    16,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider(
                                      create: (_) => DriverEmergencyCubit(),
                                      child: NavigationPage(
                                        request: request!,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.map,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "Open Map",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
