import 'package:objectbox/objectbox.dart';


@Entity()
class SleepLog {
  int id = 0;

  @Index()
  String uid = '';

  @Property(type: PropertyType.date)
  late DateTime date;
  @Property(type: PropertyType.date)
  late DateTime bedTime;
  @Property(type: PropertyType.date)
  late DateTime wakeTime;
  late int qualityRating;
  String notes = '';

  double get durationHours =>
      wakeTime.difference(bedTime).inMinutes / 60;

  String get durationFormatted {
    final hours   = durationHours.floor();
    final minutes = ((durationHours - hours) * 60).round();
    return '${hours}h ${minutes}min';
  }

  String get qualityLabel {
    switch (qualityRating) {
      case 1: return 'Terrible';
      case 2: return 'Poor';
      case 3: return 'Fair';
      case 4: return 'Good';
      case 5: return 'Excellent';
      default: return 'Unknown';
    }
  }
}




