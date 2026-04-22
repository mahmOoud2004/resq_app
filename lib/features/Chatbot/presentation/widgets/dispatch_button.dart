import 'package:flutter/material.dart';

class DispatchButton extends StatelessWidget {
  final VoidCallback onTap;

  const DispatchButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.radar, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Send Emergency Request",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
