import 'package:isar/isar.dart';

part 'weight_log.g.dart';

@collection
class WeightLog {
  Id id = Isar.autoIncrement;

  @Index()
  late String uid;

  late DateTime date;
  late double weightKg;
  String notes = '';    // optional: "after workout", "morning"

// BMI calculation requires height — we pull from UserProfile
// This model just stores raw weight — BMI computed at screen level
}