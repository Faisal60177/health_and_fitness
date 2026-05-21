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
    _stepSub = Pedometer.stepCountStream.listen((event) {
      FlutterForegroundTask.sendDataToMain({'steps': event.steps});
    });
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
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
        eventAction: ForegroundTaskEventAction.repeat(30000), // every 30s
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: false,
      ),
    );
  }

  static Future<bool> start() async {
    if (await FlutterForegroundTask.isRunningService) return true;

    final result = await FlutterForegroundTask.startService(
      serviceId:        256,   // any unique int
      notificationTitle: 'Health Tracker Active',
      notificationText:  'Counting your steps',
      callback:           startCallback,
    );
    return result is ServiceRequestSuccess;
  }

  static Future<bool> stop() async {
    final result = await FlutterForegroundTask.stopService();
    return result is ServiceRequestSuccess;
  }

  static Future<bool> get isRunning =>
      FlutterForegroundTask.isRunningService;
}