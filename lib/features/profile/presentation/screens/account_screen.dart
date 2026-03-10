import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// بيانات مؤقتة لحد ما تربط بالـ API
    final String firstName = "Mahmoud";
    final String lastName = "Mans";
    final String phone = "+201012345678";
    final String email = "mahmoud@email.com";
    final String nationalId = "298xxxxxxxxxxxx";

    return Scaffold(
      backgroundColor: const Color(0xFF07142A),

      appBar: AppBar(
        title: const Text("Account", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF07142A),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            /// Avatar
            const Center(
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Color(0xFF2563EB),
                child: Icon(Icons.person, color: Colors.white, size: 40),
              ),
            ),

            const SizedBox(height: 30),

            _infoCard("First Name", firstName),
            const SizedBox(height: 14),

            _infoCard("Last Name", lastName),
            const SizedBox(height: 14),

            _infoCard("Phone Number", phone),
            const SizedBox(height: 14),

            _infoCard("Email", email),
            const SizedBox(height: 14),

            _infoCard("National ID", nationalId),

            const SizedBox(height: 25),

            const Text(
              "ID Card Image",
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),

            const SizedBox(height: 10),

            /// صورة البطاقة
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF13294B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(Icons.image, color: Colors.white54, size: 40),
              ),
            ),

            const SizedBox(height: 30),

            /// زر التعديل
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () {},

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                child: const Text(
                  "Edit Profile",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFF13294B),
        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(title, style: const TextStyle(color: Colors.white54)),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
