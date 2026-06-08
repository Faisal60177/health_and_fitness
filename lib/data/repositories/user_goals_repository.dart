import 'package:health_and_fitness/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import '../models/user_goals.dart';
import '../services/objectbox_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserGoalsRepository {
  Box<UserGoals> get _box => ObjectBoxService.userGoals;

  String get _uid =>
      FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

  Future<UserGoals> getGoals() async {
    final existing = _box.query(
      UserGoals_.uid.equals(_uid),
    ).build().findFirst();

    if (existing != null) return existing;

    final defaults = UserGoals()..uid = _uid;
    _box.put(defaults);
    return defaults;
  }

  Future<void> saveGoals(UserGoals goals) async {
    goals.uid = _uid;
    _box.put(goals);
  }

  Future<void> updateDailyStepGoal(int newGoal) async {
    final goals = await getGoals();
    goals.dailyStepGoal = newGoal;
    await saveGoals(goals);
  }

  Stream<UserGoals?> watchGoals() {
    return _box.query(UserGoals_.uid.equals(_uid))
        .watch(triggerImmediately: true)
        .map((q) => q.findFirst());
  }
}




