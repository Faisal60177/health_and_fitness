import 'package:isar/isar.dart';
import '../models/workout_log.dart';
import '../services/isar_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutRepository {
  final _db = IsarService.db;
  // Single helper — gets current uid once, used by all methods
  String get _uid =>
      FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

// Save a new session or update existing
  Future<void> saveSession(WorkoutSession session)async{
    session.uid = _uid;                  // ← stamp uid before saving
    await _db.writeTxn(() async {
      await _db.workoutSessions.put(session);

    });
  }

  // Get all sessions — newest first
  Future<List<WorkoutSession>> getAllSessions() async{
    return _db.workoutSessions
        .where()
        .uidEqualTo(_uid)          // ← filter by uid
        .sortByDateDesc()
        .findAll();
  }

  // Get sessions for a specific date
  Future<List<WorkoutSession>> getSessionsForDate(DateTime date) async{
    // Isar date range: from midnight to just before next midnight
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    return _db.workoutSessions
        .filter()
        .uidEqualTo(_uid)          // ← filter by uid
        .dateBetween(start, end)
        .findAll();
  }



  Future<void> deleteSession(int id) async {
    await _db.writeTxn(() async {
      await _db.workoutSessions.delete(id);
    });
  }

  // Stream for live updates — Phase 4 dashboard uses this
  Stream<List<WorkoutSession>> watchRecentSessions({int limit = 7}) {
    return _db.workoutSessions
        .where()
        .uidEqualTo(_uid)          // ← filter by uid
        .sortByDateDesc()
        .limit(limit)
        .watch(fireImmediately: true);
  }


}