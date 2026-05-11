import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:resq_app/features/smart_ai_assistant/domain/entities/ai_analysis_result.dart';

import 'schedule_generator_service.dart';

@pragma('vm:entry-point')
void notificationTapBackground(
  NotificationResponse notificationResponse,
) {
  debugPrint(
    'Background notification clicked: ${notificationResponse.payload}',
  );
}

class AssistantNotificationManager {
  static final AssistantNotificationManager _instance =
      AssistantNotificationManager._internal();

  factory AssistantNotificationManager() => _instance;

  AssistantNotificationManager._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  int _notificationIdCounter = 1000;

  Future<void> init() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings =
        InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse response) async {
        debugPrint(
          'Notification clicked: ${response.payload}',
        );
      },
      onDidReceiveBackgroundNotificationResponse:
          notificationTapBackground,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  Future<void> scheduleMedicationReminders(
    List<MedicationEntity> medications,
  ) async {
    await init();

    for (var med in medications) {
      final times =
          ScheduleGeneratorService.generateScheduleTimes(
        med.frequency,
      );

      for (var time in times) {
        final now = DateTime.now();

        DateTime scheduledDate = DateTime(
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        );

        if (scheduledDate.isBefore(now)) {
          scheduledDate = scheduledDate.add(
            const Duration(days: 1),
          );
        }

        await _scheduleNotification(
          id: _notificationIdCounter++,
          title: '💊 Time for ${med.name}',
          body:
              'Dose: ${med.dose} - ${med.frequency}',
          scheduledDate: scheduledDate,
          repeat: true,
        );
      }
    }
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required bool repeat,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'medication_channel',
      'Medications',
      channelDescription:
          'Reminders to take your medication',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails =
        DarwinNotificationDetails();

    const NotificationDetails notificationDetails =
        NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(
        scheduledDate,
        tz.local,
      ),
      notificationDetails: notificationDetails,
      androidScheduleMode:
          AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents:
          repeat ? DateTimeComponents.time : null,
    );

    debugPrint(
      "Scheduled $title for $scheduledDate",
    );
  }

  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}