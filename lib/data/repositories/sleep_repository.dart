import 'package:health_and_fitness/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import '../models/sleep_log.dart';
import '../services/objectbox_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SleepRepository {
  Box<SleepLog> get _box => ObjectBoxService.sleepLogs;

  String get _uid =>
      FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

  Future<void> logSleep(SleepLog log) async {
    log.uid = _uid;
    _box.put(log);
  }

  Future<void> deleteLog(int id) async {
    _box.remove(id);
  }

  Future<List<SleepLog>> getRecentNights(int nights) async {
    final from = DateTime.now()
        .subtract(Duration(days: nights))
        .millisecondsSinceEpoch;
    final query = _box.query(
      SleepLog_.uid.equals(_uid)
          .and(SleepLog_.date.greaterThan(from)),
    )..order(SleepLog_.date, flags: Order.descending);
    return query.build().find();
  }

  Future<List<SleepLog>> getAllLogs() async {
    final query = _box.query(SleepLog_.uid.equals(_uid))
      ..order(SleepLog_.date, flags: Order.descending);
    return query.build().find();
  }

  Future<double> getAverageDuration(int nights) async {
    final logs = await getRecentNights(nights);
    if (logs.isEmpty) return 0;
    return logs.fold(0.0, (s, l) => s + l.durationHours) / logs.length;
  }

  Stream<List<SleepLog>> watchRecent() {
    final query = _box.query(SleepLog_.uid.equals(_uid))
      ..order(SleepLog_.date, flags: Order.descending);
    return query.watch(triggerImmediately: true)
        .map((q) => q.find().take(30).toList());
  }
}




