import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:resq_app/features/smart_health_notifications/data/disease_notifications.dart';

import '../data/medical_profile_storage.dart';
import '../models/medical_profile_model.dart';

import 'notification_scheduler.dart';
import 'notification_service.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();

  factory NotificationManager() => _instance;

  NotificationManager._internal();

  final NotificationService _notificationService = NotificationService();

  final NotificationScheduler _scheduler = NotificationScheduler();

  final MedicalProfileStorage _storage = MedicalProfileStorage();

  bool _initialized = false;

  /// INIT
  Future<void> init() async {
    if (_initialized) return;

    await _notificationService.init();

    await _notificationService.requestPermissions();

    await _scheduler.init();

    _initialized = true;

    debugPrint(
      "NotificationManager initialized",
    );
  }

  /// TEST NOTIFICATION
  Future<void> showTestNotification() async {
    await init();

    await _notificationService.plugin.show(
      id: 999,
      title: 'ResQ Test 🚑',
      body: 'هذا إشعار تجريبي من نظام التنبيهات الذكي',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Notifications',
          channelDescription: 'Testing notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  /// MAIN SETUP
  Future<void> setupNotifications() async {
    await init();

    /// حذف أي إشعارات قديمة
    await cancelAllNotifications();

    final MedicalProfileModel? profile = await _storage.getProfile();

    if (profile == null) {
      debugPrint("No medical profile found");
      return;
    }

    if (profile.diseases.isEmpty) {
      debugPrint("No diseases selected");
      return;
    }

    int notificationId = 1;

    for (final disease in profile.diseases) {
      final tip = await DiseaseNotifications.getRandomTip(disease);

      /// Morning notification
      await _scheduler.scheduleDailyNotification(
        id: notificationId++,
        title: "ResQ Health 💙",
        body: tip,
        hour: 10,
        minute: 0,
      );

      /// Evening notification
      final eveningTip = await DiseaseNotifications.getRandomTip(disease);

      await _scheduler.scheduleDailyNotification(
        id: notificationId++,
        title: "ResQ Reminder 🩺",
        body: eveningTip,
        hour: 7,
        minute: 0,
      );

      debugPrint(
        "Scheduled notifications for $disease",
      );
    }

    debugPrint(
      "All smart notifications scheduled successfully",
    );
  }

  /// CANCEL ALL
  Future<void> cancelAllNotifications() async {
    await _scheduler.cancelAll();

    debugPrint("All notifications cancelled");
  }
}
