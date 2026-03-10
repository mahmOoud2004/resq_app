import 'package:flutter/material.dart';
import '../widgets/profile_item_card.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07142A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF07142A),
        elevation: 0,
        title: const Text("Support & Information"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ProfileItemCard(
              icon: Icons.help_outline,
              title: "Help Center",
              subtitle: "Find answers to common questions",
              onTap: () {},
            ),

            const SizedBox(height: 16),

            ProfileItemCard(
              icon: Icons.support_agent,
              title: "Contact Support",
              subtitle: "Reach out to our support team",
              onTap: () {},
            ),

            const SizedBox(height: 16),

            ProfileItemCard(
              icon: Icons.bug_report,
              title: "Report a Problem",
              subtitle: "Tell us if something went wrong",
              onTap: () {},
            ),

            const SizedBox(height: 16),

            ProfileItemCard(
              icon: Icons.info_outline,
              title: "About ResQ",
              subtitle: "Learn more about the application",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
