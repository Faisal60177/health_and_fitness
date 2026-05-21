import 'package:isar/isar.dart';
import '../models/food_log.dart';
import '../services/isar_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FoodRepository {
  final _db = IsarService.db;

  // Single helper — gets current uid once, used by all methods
  String get _uid =>
      FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

  Future<void> logFood(FoodLog entry) async {
    entry.uid = _uid;                    // ← stamp uid before saving
    await _db.writeTxn(() async {
      await _db.foodLogs.put(entry);
    });
  }

  Future<void> deleteLog(int id) async {
    await _db.writeTxn(() async {
      await _db.foodLogs.delete(id);
    });
  }

  // Get all food logs for a specific day
  Future<List<FoodLog>> getLogsForDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return _db.foodLogs
        .filter()
        .uidEqualTo(_uid)          // ← filter by uid
        .dateBetween(start, end)
        .findAll();
  }

  // Summary for today — total calories + macros
  // Used by the home dashboard card
  Future<Map<String, double>> getTodaySummary() async {
    final logs = await getLogsForDate(DateTime.now());
    return {
      'calories': logs.fold(0.0, (s, f) => s + f.calories),
      'protein':  logs.fold(0.0, (s, f) => s + f.proteinG),
      'carbs':    logs.fold(0.0, (s, f) => s + f.carbsG),
      'fat':      logs.fold(0.0, (s, f) => s + f.fatG),
    };
  }

  Stream<List<FoodLog>> watchTodayLogs() {
    final now   = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);      // ← fixed
    final end   = start.add(const Duration(days: 1));
    return _db.foodLogs
        .filter()
        .uidEqualTo(_uid)          // ← filter by uid
        .dateBetween(start, end)
        .watch(fireImmediately: true);
  }
}

// Dart extension — adds a helper on DateTime for midnight calculation
extension DateTimeExt on DateTime {
  DateTime get dayStart => DateTime(year, month, day);
}