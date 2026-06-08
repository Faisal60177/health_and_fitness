import 'dart:async';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:health/health.dart';
import 'package:pedometer/pedometer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:health_and_fitness/objectbox.g.dart';
import 'package:health_and_fitness/data/models/step_entry.dart';
import 'package:objectbox/objectbox.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(_StepTaskHandler());
}

class _StepTaskHandler extends TaskHandler {
  StreamSubscription<StepCount>? _stepSub;
  int    _lastSavedSteps = 0;
  Store? _store;           // single store instance for the service lifetime

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // Open ObjectBox once — reused for every sync
    try {
      final dir = await getApplicationDocumentsDirectory();
      _store = await openStore(directory: '${dir.path}/objectbox');
    } catch (_) {}

    // Start pedometer for live steps
    _stepSub = Pedometer.stepCountStream.listen(
          (event) {
        FlutterForegroundTask.sendDataToMain({'steps': event.steps});
      },
      onError: (_) {},
    );

    await _syncHealthSteps();
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
        await _saveStepsToLocalDB(steps);
      }
    } catch (_) {}
  }

  Future<void> _saveStepsToLocalDB(int steps) async {
    try {
      if (_store == null) return;
      final box   = _store!.box<StepEntry>();
      final now   = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final existing = box
          .query(StepEntry_.date.equals(today.millisecondsSinceEpoch))
          .build()
          .findFirst();

      if (existing != null) {
        existing.stepCount = steps;
        box.put(existing);
      } else {
        box.put(StepEntry()
          ..date      = today
          ..stepCount = steps
          ..dailyGoal = 10000);
      }
    } catch (_) {}
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await _stepSub?.cancel();
    _store?.close();
    _store = null;
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

  static Future<void> requestPermissionAndStart() async {
    final health = Health();
    await health.configure();
    final granted = await health.requestAuthorization([
      HealthDataType.STEPS,
    ]);
    if (granted) await start();
  }
}