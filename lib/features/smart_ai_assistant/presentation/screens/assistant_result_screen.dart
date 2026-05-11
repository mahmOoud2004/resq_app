import 'package:flutter/material.dart';
import 'package:resq_app/core/constants/app_color.dart';
import '../../domain/entities/ai_analysis_result.dart';
import '../../services/google_calendar_service.dart';
import '../../services/notification_manager.dart';

class SmartAssistantResultScreen extends StatelessWidget {
  final AiAnalysisResult result;

  const SmartAssistantResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Analysis Results"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Possible Condition", Icons.healing, Colors.orange),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  result.possibleCondition,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Disclaimer: AI assistance is not a medical diagnosis. Please consult a doctor.",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
            const SizedBox(height: 24),

            if (result.medications.isNotEmpty) ...[
              _buildSectionHeader("Medications", Icons.medication, Colors.blue),
              ...result.medications.map((m) => Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.local_pharmacy, color: AppColors.primary),
                  title: Text(m.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${m.dose} • ${m.frequency} • ${m.duration}"),
                ),
              )),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Setting up reminders & syncing to Calendar...")),
                    );
                    
                    // Local Notifications
                    await AssistantNotificationManager().scheduleMedicationReminders(result.medications);
                    
                    // Google Calendar
                    final success = await GoogleCalendarService.syncMedicationsToCalendar(result.medications);
                    
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success ? "Successfully synced to Google Calendar and set Reminders!" : "Set Reminders, but Calendar Sync failed or was canceled."),
                          backgroundColor: success ? Colors.green : Colors.orange,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.calendar_month),
                  label: const Text("Add to Google Calendar & Reminders"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            if (result.tips.isNotEmpty) ...[
              _buildSectionHeader("Smart Tips", Icons.lightbulb, Colors.amber),
              ...result.tips.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(t, style: const TextStyle(fontSize: 15))),
                  ],
                ),
              )),
              const SizedBox(height: 24),
            ],

            if (result.warnings.isNotEmpty) ...[
              _buildSectionHeader("Warnings", Icons.warning, Colors.red),
              ...result.warnings.map((w) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(w, style: const TextStyle(fontSize: 15, color: Colors.red))),
                  ],
                ),
              )),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
