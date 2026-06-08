import 'dart:convert';
import 'package:objectbox/objectbox.dart';


class PlanExercise {
  String exerciseId   = '';
  String exerciseName = '';
  String muscleGroup  = '';
  int    sets         = 3;
  int    reps         = 10;
  int    restSeconds  = 90;
  String gifUrl       = '';

  PlanExercise();

  Map<String, dynamic> toJson() => {
    'exerciseId': exerciseId, 'exerciseName': exerciseName,
    'muscleGroup': muscleGroup, 'sets': sets, 'reps': reps,
    'restSeconds': restSeconds, 'gifUrl': gifUrl,
  };

  factory PlanExercise.fromJson(Map<String, dynamic> j) => PlanExercise()
    ..exerciseId   = j['exerciseId']   as String? ?? ''
    ..exerciseName = j['exerciseName'] as String? ?? ''
    ..muscleGroup  = j['muscleGroup']  as String? ?? ''
    ..sets         = j['sets']         as int? ?? 3
    ..reps         = j['reps']         as int? ?? 10
    ..restSeconds  = j['restSeconds']  as int? ?? 90
    ..gifUrl       = j['gifUrl']       as String? ?? '';
}

class PlanDay {
  int    dayNumber = 0;
  String dayLabel  = '';
  bool   isRestDay = false;
  List<PlanExercise> exercises = [];

  PlanDay();

  Map<String, dynamic> toJson() => {
    'dayNumber': dayNumber, 'dayLabel': dayLabel,
    'isRestDay': isRestDay,
    'exercises': exercises.map((e) => e.toJson()).toList(),
  };

  factory PlanDay.fromJson(Map<String, dynamic> j) => PlanDay()
    ..dayNumber  = j['dayNumber'] as int? ?? 0
    ..dayLabel   = j['dayLabel']  as String? ?? ''
    ..isRestDay  = j['isRestDay'] as bool? ?? false
    ..exercises  = (j['exercises'] as List? ?? [])
        .map((e) => PlanExercise.fromJson(e as Map<String, dynamic>))
        .toList();
}

@Entity()
class WorkoutPlan {
  int id = 0;

  @Index()
  String uid = '';

  late String   name;
  late String   description;
  late String   difficulty;
  late String   goal;
  late int      durationWeeks;
  late int      daysPerWeek;
  @Property(type: PropertyType.date)
  late DateTime createdAt;
  bool isTemplate = true;
  int  currentWeek = 1;
  int  currentDay  = 1;

  // Days stored as JSON
  String daysJson = '[]';

  List<PlanDay> get days {
    final list = jsonDecode(daysJson) as List;
    return list
        .map((d) => PlanDay.fromJson(d as Map<String, dynamic>))
        .toList();
  }

  set days(List<PlanDay> value) {
    daysJson = jsonEncode(value.map((d) => d.toJson()).toList());
  }

  double get progressPercent {
    final totalDays = durationWeeks * daysPerWeek;
    final doneDays  = (currentWeek - 1) * daysPerWeek + currentDay;
    return (doneDays / totalDays).clamp(0.0, 1.0);
  }
}





