import 'package:isar/isar.dart';

part 'sleep_log.g.dart';

// Sleep quality scale stored as int
// 1 = terrible, 2 = poor, 3 = fair, 4 = good, 5 = excellent
@collection
class SleepLog {
  Id id = Isar.autoIncrement;

  @Index()
  late String uid;

  late DateTime date;           // the date this sleep ENDED (morning of)
  late DateTime bedTime;        // when user went to bed
  late DateTime wakeTime;       // when user woke up
  late int qualityRating;       // 1–5 scale
  String notes = '';

  // Duration calculated from bed/wake times
  // Returns hours as a double (7.5 = 7h 30min)
  double get durationHours {
    final diff = wakeTime.difference(bedTime);
    return diff.inMinutes / 60;
  }

  // Formatted string: "7h 30min"
  String get durationFormatted {
    final hours = durationHours.floor();
    final minutes = ((durationHours - hours) * 60).round();
    return '${hours}h ${minutes}min';
  }

  // Quality label from numeric rating
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