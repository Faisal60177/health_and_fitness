import 'package:isar/isar.dart';
import '../models/step_entry.dart';
import '../services/isar_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StepRepository {
  final _db = IsarService.db;

  // Single helper — gets current uid once, used by all methods
  String get _uid =>
      FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

  // Upsert today's step count
  // Called by the pedometer provider whenever step count updates
  Future<void> saveTodaySteps(int steps) async {
    final today = _todayMidnight();

    await _db.writeTxn(() async {
      // Find existing entry FOR THIS USER on today's date
      final existing = await _db.stepEntrys
          .filter()
          .uidEqualTo(_uid)          // ← filter by uid
          .dateEqualTo(today)
          .findFirst();

      if (existing != null) {
        // Update existing entry
        existing.stepCount = steps;
        await _db.stepEntrys.put(existing);
      } else {
        // Create new entry for today
        final entry = StepEntry()
          ..uid       = _uid          // ← stamp uid on new records
          ..date = today
          ..stepCount = steps
          ..dailyGoal = 10000;
        await _db.stepEntrys.put(entry);
      }
    });
  }

  // Get today's entry — null if no steps logged yet today
  Future<StepEntry?> getTodayEntry() async {
    return _db.stepEntrys
        .filter()
        .uidEqualTo(_uid)          // ← filter by uid
        .dateEqualTo(_todayMidnight())
        .findFirst();
  }

  // Get last N days for the weekly chart (Phase 4)
  Future<List<StepEntry>> getRecentDays(int days) async {
    final from = DateTime.now().subtract(Duration(days: days));
    return _db.stepEntrys
        .filter()
        .uidEqualTo(_uid)          // ← filter by uid
        .dateGreaterThan(from)
        .sortByDate()
        .findAll();
  }

  Stream<StepEntry?> watchToday() {
    return _db.stepEntrys
        .filter()
        .uidEqualTo(_uid)          // ← filter by uid
        .dateEqualTo(_todayMidnight())
        .watch(fireImmediately: true)
        .map((list) => list.isEmpty ? null : list.first);
  }

  // Helper — strips hours/minutes so date comparison works correctly
  DateTime _todayMidnight() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}