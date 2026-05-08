import 'package:flutter/material.dart';
import 'package:resq_app/core/theme/theme_ext.dart';
import 'package:resq_app/core/constants/app_color.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: context.surfaceLightColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.borderColor),
        ),

        child: Row(
          children: [
            Icon(icon, color: color ?? Colors.white),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                title,
                style: TextStyle(color: color ?? Colors.white, fontSize: 16),
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }
}
