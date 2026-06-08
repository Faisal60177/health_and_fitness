import 'package:health_and_fitness/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import '../models/workout_log.dart';
import '../services/objectbox_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutRepository {
  Box<WorkoutSession> get _box => ObjectBoxService.workoutSessions;

  String get _uid =>
      FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

  Future<void> saveSession(WorkoutSession session) async {
    session.uid = _uid;
    _box.put(session);
  }

  Future<List<WorkoutSession>> getAllSessions() async {
    final query = _box.query(WorkoutSession_.uid.equals(_uid))
      ..order(WorkoutSession_.date, flags: Order.descending);
    return query.build().find();
  }

  Future<List<WorkoutSession>> getSessionsForDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end   = start.add(const Duration(days: 1));
    return _box.query(
      WorkoutSession_.uid.equals(_uid)
          .and(WorkoutSession_.date.between(
        start.millisecondsSinceEpoch,
        end.millisecondsSinceEpoch,
      )),
    ).build().find();
  }

  Future<void> deleteSession(int id) async {
    _box.remove(id);
  }

  Stream<List<WorkoutSession>> watchRecentSessions({int limit = 7}) {
    final query = _box.query(WorkoutSession_.uid.equals(_uid))
      ..order(WorkoutSession_.date, flags: Order.descending);
    return query.watch(triggerImmediately: true)
        .map((q) => q.find().take(limit).toList());
  }
}




