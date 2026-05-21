import 'package:firebase_auth/firebase_auth.dart';
import 'package:isar/isar.dart';
import '../models/user_goals.dart';
import '../services/isar_service.dart';

class UserGoalsRepository {
  final _db = IsarService.db;

  String get _uid =>
      FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

  Future<UserGoals> getGoals() async {
    final existing = await _db.userGoals
        .filter()
        .uidEqualTo(_uid)
        .findFirst();

    if (existing != null) return existing;

    // Create default goals for this user on first access
    final defaults = UserGoals()..uid = _uid;
    await _db.writeTxn(() async {
      await _db.userGoals.put(defaults);
    });
    return defaults;
  }

  Future<void> saveGoals(UserGoals goals) async {
    goals.uid = _uid;
    await _db.writeTxn(() async {
      await _db.userGoals.put(goals);
    });
  }

  // Update just the step goal — called from goal settings screen
  Future<void> updateDailyStepGoal(int newGoal) async {
    final goals = await getGoals();
    goals.dailyStepGoal = newGoal;
    await saveGoals(goals);
  }

  Stream<UserGoals?> watchGoals() {
    return _db.userGoals
        .filter()
        .uidEqualTo(_uid)
        .watch(fireImmediately: true)
        .map((list) => list.isEmpty ? null : list.first);
  }
}