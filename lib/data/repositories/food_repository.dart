import 'package:health_and_fitness/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import '../models/food_log.dart';
import '../services/objectbox_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FoodRepository {
  Box<FoodLog> get _box => ObjectBoxService.foodLogs;

  String get _uid =>
      FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

  Future<void> logFood(FoodLog entry) async {
    entry.uid = _uid;
    _box.put(entry);
  }

  Future<void> deleteLog(int id) async {
    _box.remove(id);
  }

  // Single day — used by dashboard today summary
  Future<List<FoodLog>> getLogsForDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end   = start.add(const Duration(days: 1));
    return _box.query(
      FoodLog_.uid.equals(_uid)
          .and(FoodLog_.date.between(
        start.millisecondsSinceEpoch,
        end.millisecondsSinceEpoch,
      )),
    ).build().find();
  }

  // Date range — used by analytics/charts for 7D or 30D view
  Future<List<FoodLog>> getLogsForRange(
      DateTime from, DateTime to) async {
    return _box.query(
      FoodLog_.uid.equals(_uid)
          .and(FoodLog_.date.between(
        from.millisecondsSinceEpoch,
        to.millisecondsSinceEpoch,
      )),
    ).build().find();
  }

  // Summary for today — total calories + macros
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
    final start = DateTime(now.year, now.month, now.day);
    final end   = start.add(const Duration(days: 1));
    return _box.query(
      FoodLog_.uid.equals(_uid)
          .and(FoodLog_.date.between(
        start.millisecondsSinceEpoch,
        end.millisecondsSinceEpoch,
      )),
    ).watch(triggerImmediately: true).map((q) => q.find());
  }
}

extension DateTimeExt on DateTime {
  DateTime get dayStart => DateTime(year, month, day);
}