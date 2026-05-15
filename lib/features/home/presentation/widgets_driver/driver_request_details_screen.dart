import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/core/widgets/resolved_location_text.dart';
import 'package:resq_app/features/driver_emergency/data/models/driver_request_model.dart';
import 'package:resq_app/features/driver_emergency/presentation/cubit/driver_emergency_cubit.dart';
import 'package:resq_app/features/home/presentation/widgets_driver/navigation_page.dart';

class DriverRequestDetailsScreen extends StatelessWidget {
  final DriverRequestModel request;

  const DriverRequestDetailsScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final isOnline = context.watch<DriverEmergencyCubit>().isOnline;

    return Scaffold(
      backgroundColor: const Color(0xFF081A33),

      appBar: AppBar(
        backgroundColor: const Color(0xFF081A33),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Emergency Request",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔥 HEADER
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F2747),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.warning, color: Colors.white),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "New Emergency Request",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 📍 LOCATION CARD
            _buildCard(
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ResolvedLocationText(
                      latitude: request.latitude,
                      longitude: request.longitude,
                      maxLines: 2,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            /// 👤 USER INFO CARD
            _buildCard(
              child: Column(
                children: [
                  _infoRow(Icons.person, "User", request.userName ?? "Unknown"),
                  const SizedBox(height: 12),
                  _infoRow(Icons.phone, "Phone", request.userPhone ?? "-"),
                  const SizedBox(height: 12),
                  _infoRow(Icons.build, "Service", request.serviceType),
                ],
              ),
            ),

            const Spacer(),

            /// 🔥 BUTTONS
            Row(
              children: [
                /// ❌ Reject
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () async {
                      await context.read<DriverEmergencyCubit>().cancel(
                        request.id,
                      );
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Reject",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                /// ✅ Accept
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOnline ? Colors.red : Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: !isOnline
                        ? null
                        : () async {
                      await context.read<DriverEmergencyCubit>().accept(
                        request.id,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context
                                .read<DriverEmergencyCubit>(), // 🔥 نفس الكيوبت
                            child: NavigationPage(request: request),
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Accept",
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

  /// 🔥 reusable card
  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2747),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
        ],
      ),
      child: child,
    );
  }

  /// 🔥 row with icon
  Widget _infoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 10),
        Text("$title:", style: const TextStyle(color: Colors.white54)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
