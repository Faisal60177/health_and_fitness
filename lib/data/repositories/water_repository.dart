import 'package:health_and_fitness/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import '../models/water_log.dart';
import '../services/objectbox_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WaterRepository {
  Box<WaterLog> get _box => ObjectBoxService.waterLogs;

  String get _uid =>
      FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

  Future<void> logWater(int amountML) async {
    final now = DateTime.now();
    _box.put(WaterLog()
      ..uid      = _uid
      ..date     = DateTime(now.year, now.month, now.day)
      ..amountML = amountML
      ..time     = now);
  }

  Future<void> deleteLog(int id) async {
    _box.remove(id);
  }

  Future<int> getTodayTotal() async {
    final logs = await getTodayLogs();
    return logs.fold<int>(0, (sum, log) => sum + log.amountML);
  }

  Future<List<WaterLog>> getTodayLogs() async {
    final now   = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end   = start.add(const Duration(days: 1));
    final query = _box.query(
      WaterLog_.uid.equals(_uid)
          .and(WaterLog_.date.between(
        start.millisecondsSinceEpoch,
        end.millisecondsSinceEpoch,
      )),
    )..order(WaterLog_.time, flags: Order.descending);
    return query.build().find();
  }

  Stream<List<WaterLog>> watchTodayLogs() {
    final now   = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end   = start.add(const Duration(days: 1));
    return _box.query(
      WaterLog_.uid.equals(_uid)
          .and(WaterLog_.date.between(
        start.millisecondsSinceEpoch,
        end.millisecondsSinceEpoch,
      )),
    ).watch(triggerImmediately: true).map((q) => q.find());
  }
}




