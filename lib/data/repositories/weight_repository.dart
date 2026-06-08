import 'package:health_and_fitness/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import '../models/weight_log.dart';
import '../services/objectbox_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WeightRepository {
  Box<WeightLog> get _box => ObjectBoxService.weightLogs;

  String get _uid =>
      FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

  Future<void> logWeight(double kg, {String notes = ''}) async {
    _box.put(WeightLog()
      ..uid      = _uid
      ..date     = DateTime.now()
      ..weightKg = kg
      ..notes    = notes);
  }

  Future<WeightLog?> getLatest() async {
    final query = _box.query(WeightLog_.uid.equals(_uid))
      ..order(WeightLog_.date, flags: Order.descending);
    return query.build().findFirst();
  }

  Future<List<WeightLog>> getHistory() async {
    final query = _box.query(WeightLog_.uid.equals(_uid))
      ..order(WeightLog_.date, flags: Order.descending);
    return query.build().find();
  }

  Stream<List<WeightLog>> watchHistory() {
    final query = _box.query(WeightLog_.uid.equals(_uid))
      ..order(WeightLog_.date, flags: Order.descending);
    return query.watch(triggerImmediately: true)
        .map((q) => q.find());
  }
}




