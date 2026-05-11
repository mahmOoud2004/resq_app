import 'package:flutter/material.dart';

class ScheduleGeneratorService {
  /// Parses phrases like "every 8 hours", "twice a day", "once daily" 
  /// and returns a list of specific TimeOfDay representing the schedule.
  static List<TimeOfDay> generateScheduleTimes(String frequencyText) {
    final lowerFreq = frequencyText.toLowerCase();
    
    // Default fallback
    List<TimeOfDay> times = [const TimeOfDay(hour: 9, minute: 0)];

    if (lowerFreq.contains("every 8 hours") || lowerFreq.contains("3 times")) {
      times = [
        const TimeOfDay(hour: 8, minute: 0),
        const TimeOfDay(hour: 16, minute: 0), // 4:00 PM
        const TimeOfDay(hour: 23, minute: 59), // Midnight roughly
      ];
    } else if (lowerFreq.contains("every 12 hours") || lowerFreq.contains("twice") || lowerFreq.contains("2 times")) {
      times = [
        const TimeOfDay(hour: 9, minute: 0),
        const TimeOfDay(hour: 21, minute: 0), // 9:00 PM
      ];
    } else if (lowerFreq.contains("every 6 hours") || lowerFreq.contains("4 times")) {
      times = [
        const TimeOfDay(hour: 6, minute: 0),
        const TimeOfDay(hour: 12, minute: 0),
        const TimeOfDay(hour: 18, minute: 0),
        const TimeOfDay(hour: 23, minute: 59),
      ];
    } else if (lowerFreq.contains("once") || lowerFreq.contains("daily")) {
      times = [
        const TimeOfDay(hour: 10, minute: 0),
      ];
    }

    return times;
  }
}
