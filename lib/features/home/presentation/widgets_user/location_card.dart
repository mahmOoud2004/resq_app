import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  final String address;

  const LocationCard({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFF13294B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E3A6D)),
      ),

      child: Row(
        children: [
          const Icon(Icons.location_on, color: Color(0xFF2563EB)),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Current Location",
                  style: TextStyle(color: Color(0xff94A3B8)),
                ),

                const SizedBox(height: 2),

                Text(
                  address,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          TextButton(
            onPressed: () {},
            child: const Text(
              "Change",
              style: TextStyle(
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
