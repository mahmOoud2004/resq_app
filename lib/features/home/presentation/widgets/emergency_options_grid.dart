import 'package:flutter/material.dart';

class EmergencyOptionsGrid extends StatelessWidget {
  const EmergencyOptionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.3,
      ),
      children: const [
        EmergencyOptionCard(
          title: "Medical Help",
          icon: Icons.medical_services,
          color: Color(0xFFFF4B4B),
        ),

        EmergencyOptionCard(
          title: "Fire Fighter",
          icon: Icons.local_fire_department,
          color: Color(0xFFFF7A00),
        ),

        EmergencyOptionCard(
          title: "Emergency Ride",
          icon: Icons.local_taxi,
          color: Color(0xFFFF7A00),
        ),

        EmergencyOptionCard(
          title: "Police Help",
          icon: Icons.shield,
          color: Color(0xFF2563EB),
        ),
      ],
    );
  }
}

class EmergencyOptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const EmergencyOptionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        /// gradient background مثل التصميم
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(.15), const Color(0xFF13294B)],
        ),

        /// border ملون
        border: Border.all(color: color.withOpacity(.7), width: 1.5),

        /// glow خفيف
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.15),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// مربع الأيقونة
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),

          const SizedBox(height: 14),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
