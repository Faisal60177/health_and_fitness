import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  // Call this once in main() before runApp()
  static Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone database
    tz.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit     = DarwinInitializationSettings(
      requestAlertPermission:  true,
      requestBadgePermission:  true,
      requestSoundPermission:  true,
    );

    await _plugin.initialize(
      settings: const InitializationSettings(
          android: androidInit, iOS: iosInit),
      // Handle notification tap — navigate to relevant screen
      onDidReceiveNotificationResponse: (details) {
        // Phase 6 adds deep-link navigation here
      },
    );

    _initialized = true;
  }

  // Request permission (Android 13+)
  static Future<bool> requestPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  // --- Immediate notification (test / one-shot) ---
  static Future<void> showInstant({
    required int id,
    required String title,
    required String body,
  }) async {
    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'health_general',    // channel ID
          'General',           // channel name
          channelDescription: 'General health reminders',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  // --- Daily repeating notification at a fixed time ---
  // Example: "Time to log your workout!" every day at 8:00 AM
  static Future<void> scheduleDailyAt({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    // Cancel any existing notification with this ID first
    await _plugin.cancel(id: id);

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: _nextInstanceOfTime(hour, minute),
      notificationDetails : const NotificationDetails(
        android: AndroidNotificationDetails(
          'health_reminders',
          'Health Reminders',
          channelDescription: 'Daily health tracking reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // repeat daily
    );
  }

  // --- Cancel a specific notification ---
  static Future<void> cancel(int id) async {
    await _plugin.cancel(id: id);
  }

  // --- Cancel all notifications ---
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  // Calculates the next occurrence of a given time
  // If the time has already passed today, schedules for tomorrow
  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now  = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  // Completion notifications — called when a goal is hit
  static Future<void> notifyStepGoalReached(int steps) async {
    await showInstant(
      id:    NotificationIds.stepGoalComplete,
      title: '🎉 Step goal reached!',
      body:  'Amazing! You\'ve walked $steps steps today. Goal complete!',
    );
  }

  static Future<void> notifyWaterGoalReached() async {
    await showInstant(
      id:    NotificationIds.waterGoalComplete,
      title: '💧 Water goal reached!',
      body:  'You\'ve hit your daily water target. Stay hydrated!',
    );
  }

  static Future<void> notifyCalorieGoalReached() async {
    await showInstant(
      id:    NotificationIds.calorieGoalComplete,
      title: '🍽️ Calorie goal reached!',
      body:  'You\'ve logged your calorie target for today.',
    );
  }

}

// Notification IDs — constants to avoid collisions
class NotificationIds {
  static const workout  = 1;
  static const water    = 2;
  static const steps    = 3;
  static const sleep    = 4;
  static const meal     = 5;
  static const weight   = 6;
  static const stepGoalComplete   = 10;
  static const waterGoalComplete  = 11;
  static const calorieGoalComplete = 12;
}



