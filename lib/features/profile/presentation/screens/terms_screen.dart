import 'package:flutter/material.dart';
import '../widgets/profile_item_card.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07142A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF07142A),
        elevation: 0,
        title: const Text("Terms & Policies"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ProfileItemCard(
              icon: Icons.privacy_tip_outlined,
              title: "Privacy Policy",
              subtitle: "How we protect your data",
              onTap: () {},
            ),

            const SizedBox(height: 16),

            ProfileItemCard(
              icon: Icons.description_outlined,
              title: "Terms of Service",
              subtitle: "Rules for using the application",
              onTap: () {},
            ),

            const SizedBox(height: 16),

            ProfileItemCard(
              icon: Icons.security,
              title: "Data Usage",
              subtitle: "How location and data are used",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
