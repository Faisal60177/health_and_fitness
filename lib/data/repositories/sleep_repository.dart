import 'package:isar/isar.dart';
import '../models/sleep_log.dart';
import '../services/isar_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SleepRepository {
  final _db = IsarService.db;

  // Single helper — gets current uid once, used by all methods
  String get _uid =>
      FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

  Future<void> logSleep(SleepLog log) async {
    log.uid = _uid;                      // ← stamp uid
    await _db.writeTxn(() async {
      await _db.sleepLogs.put(log);
    });
  }

  Future<void> deleteLog(int id) async {
    await _db.writeTxn(() async {
      await _db.sleepLogs.delete(id);
    });
  }

  // Last 7 nights for the weekly chart
  Future<List<SleepLog>> getRecentNights(int nights) async {
    final from = DateTime.now().subtract(Duration(days: nights));
    return _db.sleepLogs
        .filter()
        .uidEqualTo(_uid)          // ← filter by uid
        .dateGreaterThan(from)
        .sortByDateDesc()
        .findAll();
  }

  // Full history for analytics
  Future<List<SleepLog>> getAllLogs() async {
    return _db.sleepLogs
        .filter()
        .uidEqualTo(_uid)               // ← add uid filter
        .sortByDateDesc()
        .findAll();
  }

  // Average sleep duration over last N nights
  Future<double> getAverageDuration(int nights) async {
    final logs = await getRecentNights(nights);
    if (logs.isEmpty) return 0;
    final total = logs.fold(0.0, (s, l) => s + l.durationHours);
    return total / logs.length;
  }

  Stream<List<SleepLog>> watchRecent() {
    return _db.sleepLogs
        .filter()
        .uidEqualTo(_uid)               // ← add uid filter
        .sortByDateDesc()
        .limit(30)
        .watch(fireImmediately: true);
  }
}