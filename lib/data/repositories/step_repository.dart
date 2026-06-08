import 'package:health_and_fitness/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import '../models/step_entry.dart';
import '../services/objectbox_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StepRepository {
  Box<StepEntry> get _box => ObjectBoxService.stepEntries;

  String get _uid =>
      FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

  Future<void> saveTodaySteps(int steps) async {
    final today = _todayMidnight();
    final existing = _box.query(
      StepEntry_.uid.equals(_uid)
          .and(StepEntry_.date.equals(today.millisecondsSinceEpoch)),
    ).build().findFirst();

    if (existing != null) {
      existing.stepCount = steps;
      _box.put(existing);
    } else {
      _box.put(StepEntry()
        ..uid       = _uid
        ..date      = today
        ..stepCount = steps
        ..dailyGoal = 10000);
    }
  }

  Future<StepEntry?> getTodayEntry() async {
    return _box.query(
      StepEntry_.uid.equals(_uid)
          .and(StepEntry_.date.equals(
          _todayMidnight().millisecondsSinceEpoch)),
    ).build().findFirst();
  }

  Future<List<StepEntry>> getRecentDays(int days) async {
    final from = DateTime.now()
        .subtract(Duration(days: days))
        .millisecondsSinceEpoch;
    final query = _box.query(
      StepEntry_.uid.equals(_uid)
          .and(StepEntry_.date.greaterThan(from)),
    )..order(StepEntry_.date);
    return query.build().find();
  }

  Stream<StepEntry?> watchToday() {
    return _box.query(
      StepEntry_.uid.equals(_uid)
          .and(StepEntry_.date.equals(
          _todayMidnight().millisecondsSinceEpoch)),
    ).watch(triggerImmediately: true)
        .map((q) => q.findFirst());
  }

  DateTime _todayMidnight() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}




