import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workmanager/workmanager.dart';
import '../../firebase_options.dart';
import '../services/objectbox_service.dart';
import '../services/sync_service.dart';

// Task name — must match exactly in both registration and callback
const _dailySyncTask = 'health_daily_sync';

// This function runs in a SEPARATE ISOLATE (background process)
// It has no access to the Flutter widget tree
// It must re-initialize Firebase and Isar from scratch
@pragma('vm:entry-point')
void backgroundSyncCallback() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName != _dailySyncTask) return true;

    try {
      // Must re-initialize all services — background isolate starts fresh
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await ObjectBoxService.initialize();

      // Only sync if user is still signed in
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return true; // no user, skip silently

      await SyncService().sync(
        direction: SyncDirection.upload,
        daysBack:  1, // background only syncs yesterday + today
      );

      return true; // tell WorkManager task succeeded
    } catch (e) {
      return false; // tell WorkManager to retry later
    }
  });
}

class BackgroundSyncService {
  // Register the daily background sync task
  // Call this once after user signs in successfully
  static Future<void> register() async {
    await Workmanager().initialize(
      backgroundSyncCallback,
      isInDebugMode: false, // set true to see background task logs
    );

    await Workmanager().registerPeriodicTask(
      _dailySyncTask,       // unique task identifier
      _dailySyncTask,       // task name (matches callback)
      frequency: const Duration(hours: 24), // run once per day
      // Run at 3am local time — when phone is likely charging
      initialDelay: _timeUntil3am(),
      constraints: Constraints(
        // Only sync when connected — saves battery + data
        networkType: NetworkType.connected,
        // Only sync when charging — avoids draining battery
        requiresCharging: false, // set true for production
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );
  }

  // Cancel the background task — call on sign out
  static Future<void> cancel() async {
    await Workmanager().cancelByUniqueName(_dailySyncTask);
  }

  // Calculate delay until 3:00 AM local time
  static Duration _timeUntil3am() {
    final now    = DateTime.now();
    var   target = DateTime(now.year, now.month, now.day, 3, 0);
    if (target.isBefore(now)) {
      target = target.add(const Duration(days: 1));
    }
    return target.difference(now);
  }
}



