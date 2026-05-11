import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:resq_app/features/smart_ai_assistant/domain/entities/ai_analysis_result.dart';

import 'schedule_generator_service.dart';

class GoogleCalendarService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [calendar.CalendarApi.calendarEventsScope],
  );

  static Future<bool> syncMedicationsToCalendar(
    List<MedicationEntity> medications,
  ) async {
    try {
      final account = await _googleSignIn.signIn();

      if (account == null) {
        debugPrint("User canceled Google Sign In");
        return false;
      }

      final authClient = await _googleSignIn.authenticatedClient();

      if (authClient == null) {
        debugPrint("Failed to get authenticated client.");
        return false;
      }

      final calendarApi = calendar.CalendarApi(authClient);

      for (var med in medications) {
        final times = ScheduleGeneratorService.generateScheduleTimes(
          med.frequency,
        );

        final now = DateTime.now();

        int days = 1;

        if (med.duration.toLowerCase().contains("day")) {
          final match = RegExp(r'\d+').firstMatch(med.duration);

          if (match != null) {
            days = int.parse(match.group(0)!);
          }
        } else if (med.duration.toLowerCase().contains("week")) {
          final match = RegExp(r'\d+').firstMatch(med.duration);

          if (match != null) {
            days = int.parse(match.group(0)!) * 7;
          } else {
            days = 7;
          }
        }

        for (int d = 0; d < days; d++) {
          for (var time in times) {
            final startTime = DateTime(
              now.year,
              now.month,
              now.day + d,
              time.hour,
              time.minute,
            );

            final endTime = startTime.add(const Duration(minutes: 15));

            final event = calendar.Event(
              summary: "Medication: ${med.name}",
              description: "Dose: ${med.dose}\nFrequency: ${med.frequency}",
              start: calendar.EventDateTime(dateTime: startTime),
              end: calendar.EventDateTime(dateTime: endTime),
              reminders: calendar.EventReminders(
                useDefault: false,
                overrides: [
                  calendar.EventReminder(method: "popup", minutes: 10),
                ],
              ),
            );

            await calendarApi.events.insert(event, "primary");
          }
        }
      }

      return true;
    } catch (e) {
      debugPrint("Error syncing to Google Calendar: $e");
      return false;
    }
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
