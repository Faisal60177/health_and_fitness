import 'dart:async';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:health/health.dart';
import 'package:pedometer/pedometer.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(_StepTaskHandler());
}

class _StepTaskHandler extends TaskHandler {
  StreamSubscription<StepCount>? _stepSub;
  int _lastSavedSteps = 0;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // DO NOT request authorization here — needs UI context
    // Authorization must be done in the app UI before starting service

    // Start pedometer for live steps
    _stepSub = Pedometer.stepCountStream.listen(
          (event) {
        FlutterForegroundTask.sendDataToMain({'steps': event.steps});
      },
      onError: (e) {
        // Pedometer not available — Health Connect will handle it
      },
    );

    // Sync Health Connect immediately on start
    await _syncHealthSteps();
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // Called every 30 seconds — sync Health Connect
    _syncHealthSteps();
  }

  Future<void> _syncHealthSteps() async {
    final health = Health();
    try {
      final now   = DateTime.now();
      final start = DateTime(now.year, now.month, now.day);
      final steps = await health.getTotalStepsInInterval(start, now);
      if (steps != null && steps > _lastSavedSteps) {
        _lastSavedSteps = steps;
        FlutterForegroundTask.sendDataToMain({'healthSteps': steps});
      }
    } catch (_) {}
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await _stepSub?.cancel();
  }

  @override
  void onReceiveData(Object data) {}

  @override
  void onNotificationButtonPressed(String id) {}

  @override
  void onNotificationDismissed() {}
}

class StepForegroundService {
  static Future<void> initialize() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'step_counter',
        channelName: 'Step Counter',
        channelDescription: 'Counts your steps in the background',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        playSound: false,
        enableVibration: false,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(30000),
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: false,
      ),
    );
  }

  // Call this from UI after Health Connect permission granted
  static Future<bool> start() async {
    if (await FlutterForegroundTask.isRunningService) return true;
    final result = await FlutterForegroundTask.startService(
      serviceId:         256,
      notificationTitle: 'Health Tracker Active',
      notificationText:  'Counting your steps',
      callback:          startCallback,
    );
    return result is ServiceRequestSuccess;
  }

  static Future<bool> stop() async {
    final result = await FlutterForegroundTask.stopService();
    return result is ServiceRequestSuccess;
  }

  static Future<bool> get isRunning =>
      FlutterForegroundTask.isRunningService;

  // Call this from your Step screen or Home screen
  // Requests Health Connect permission then starts service
  static Future<void> requestPermissionAndStart() async {
    final health = Health();
    await health.configure();
    final granted = await health.requestAuthorization([
      HealthDataType.STEPS,
    ]);
    if (granted) {
      await start();
    }
  }
}