import 'package:flutter/material.dart';
import 'package:resq_app/core/theme/theme_ext.dart';

class EmergencyOptionsGrid extends StatelessWidget {
  final List<String> selected;
  final Function(String) onSelect;

  const EmergencyOptionsGrid({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.2,
      ),
      children: [
        EmergencyOptionCard(
          title: "Medical Help",
          icon: Icons.medical_services,
          color: const Color(0xFFFF4B4B),
          service: "medical",
          selected: selected.contains("medical"),
          onTap: onSelect,
        ),
        EmergencyOptionCard(
          title: "Fire Fighter",
          icon: Icons.local_fire_department,
          color: const Color(0xFFFF7A00),
          service: "fire",
          selected: selected.contains("fire"),
          onTap: onSelect,
        ),
        EmergencyOptionCard(
          title: "Emergency Ride",
          icon: Icons.local_taxi,
          color: const Color(0xFFFF7A00),
          service: "tow_truck",
          selected: selected.contains("tow_truck"),
          onTap: onSelect,
        ),
        EmergencyOptionCard(
          title: "Police Help",
          icon: Icons.shield,
          color: const Color(0xFF2563EB),
          service: "police",
          selected: selected.contains("police"),
          onTap: onSelect,
        ),
      ],
    );
  }
}

class EmergencyOptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String service;
  final bool selected;
  final Function(String) onTap;

  const EmergencyOptionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.service,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(service),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: selected ? 1.05 : 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),

            /// Gradient رجعناه
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: selected
                  ? [color.withValues(alpha: .35), context.surfaceLightColor]
                  : [color.withValues(alpha: .15), context.surfaceLightColor],
            ),

            /// border
            border: Border.all(
              color: selected ? color : color.withValues(alpha: .7),
              width: 1.5,
            ),

            /// glow
            boxShadow: [
              if (selected)
                BoxShadow(
                  color: color.withValues(alpha: .34),
                  blurRadius: 25,
                  spreadRadius: 1,
                ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(14),
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
        ),
      ),
    );
  }
}
