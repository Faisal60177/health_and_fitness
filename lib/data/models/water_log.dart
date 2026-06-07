import 'package:isar/isar.dart';

part 'water_log.g.dart';

@collection
class WaterLog {
  Id id = Isar.autoIncrement;

  @Index()
  String uid = '';

  late DateTime date;
  late int amountML;  // millilitres per drink (e.g., 250ml)
  late DateTime time; // exact time of this drink

// Convenience getter: converts ml to glasses (1 glass = 250ml)
  double get glasses => amountML / 250;

}