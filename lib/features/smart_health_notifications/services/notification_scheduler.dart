import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'notification_service.dart';

class NotificationScheduler {
  static final NotificationScheduler _instance =
      NotificationScheduler._internal();

  factory NotificationScheduler() => _instance;

  NotificationScheduler._internal();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();

      tz.setLocalLocation(tz.getLocation('Africa/Cairo'));

      final androidImplementation = NotificationService()
          .plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      // Android 13+
      await androidImplementation?.requestNotificationsPermission();

      _isInitialized = true;

      debugPrint("NotificationScheduler initialized");
    } catch (e) {
      debugPrint("NotificationScheduler init error: $e");
    }
  }

  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    await init();

    final flutterLocalNotificationsPlugin = NotificationService().plugin;

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: _nextInstanceOfTime(hour, minute),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'health_tips_channel',
            'Health Tips',
            channelDescription: 'Daily smart health tips',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      debugPrint(
        "Scheduled notification $id successfully at $hour:$minute",
      );
    } catch (e) {
      debugPrint("Schedule notification error: $e");
    }
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  Future<void> cancelAll() async {
    try {
      await NotificationService().plugin.cancelAll();

      debugPrint("All notifications cancelled");
    } catch (e) {
      debugPrint("Cancel notifications error: $e");
    }
  }
}
