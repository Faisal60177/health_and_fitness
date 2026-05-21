import 'package:isar/isar.dart';
import '../models/water_log.dart';
import '../services/isar_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WaterRepository {
  final _db = IsarService.db;

  // Single helper — gets current uid once, used by all methods
  String get _uid =>
      FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

  Future<void> logWater(int amountML) async {
    final log = WaterLog()
      ..uid       = _uid          // ← stamp uid on new records
      ..date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
      ..amountML = amountML
      ..time = DateTime.now();

    await _db.writeTxn(() async {
      await _db.waterLogs.put(log);
    });
  }

  Future<void> deleteLog(int id) async {
    await _db.writeTxn(() async {
      await _db.waterLogs.delete(id);
    });
  }

  // Total ml consumed today
  Future<int> getTodayTotal() async {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));

    final logs = await _db.waterLogs
        .filter()
        .uidEqualTo(_uid)          // ← filter by uid
        .dateBetween(start, end)
        .findAll();

    return logs.fold<int> (0, (sum, log) => sum + log.amountML);
  }

  // All individual water logs for today (shown as a list)
  Future<List<WaterLog>> getTodayLogs() async {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));

    return _db.waterLogs
        .filter()
        .uidEqualTo(_uid)          // ← filter by uid
        .dateBetween(start, end)
        .sortByTimeDesc()
        .findAll();
  }

  Stream<List<WaterLog>> watchTodayLogs() {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));

    return _db.waterLogs
        .filter()
        .uidEqualTo(_uid)          // ← filter by uid
        .dateBetween(start, end)
        .watch(fireImmediately: true);
  }
}