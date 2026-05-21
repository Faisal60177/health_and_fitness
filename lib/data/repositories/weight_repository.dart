import 'package:isar/isar.dart';
import '../models/weight_log.dart';
import '../services/isar_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WeightRepository {
  final _db = IsarService.db;
  // Single helper — gets current uid once, used by all methods
  String get _uid =>
      FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

  Future<void> logWeight(double kg, {String notes = ''}) async {
    final log = WeightLog()
      ..uid       = _uid          // ← stamp uid on new records
      ..date = DateTime.now()
      ..weightKg = kg
      ..notes = notes;

    await _db.writeTxn(() async {
      await _db.weightLogs.put(log);
    });
  }

  // Most recent weight entry
  Future<WeightLog?> getLatest() async {
    return _db.weightLogs
        .filter()
        .uidEqualTo(_uid)              // ← add uid filter
        .sortByDateDesc()
        .findFirst();
  }

  // All entries sorted newest first — for history list + chart
  Future<List<WeightLog>> getHistory() async {
    return _db.weightLogs
        .filter()
        .uidEqualTo(_uid)              // ← add uid filter
        .sortByDateDesc()
        .findAll();
  }

  Stream<List<WeightLog>> watchHistory() {
    return _db.weightLogs
        .filter()
        .uidEqualTo(_uid)              // ← add uid filter
        .sortByDateDesc()
        .watch(fireImmediately: true);
  }
}