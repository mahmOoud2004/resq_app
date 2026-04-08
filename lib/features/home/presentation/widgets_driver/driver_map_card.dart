import 'package:flutter/material.dart';

class DriverMapCard extends StatelessWidget {
  const DriverMapCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text("Map Here", style: TextStyle(color: Colors.white54)),
      ),
    );
  }
}
