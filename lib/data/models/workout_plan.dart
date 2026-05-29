import 'package:isar/isar.dart';

part 'workout_plan.g.dart';

@embedded
class PlanDay {
  late int dayNumber;
  late String dayLabel;
  late bool isRestDay;
  late List<PlanExercise> exercises;
  PlanDay() { exercises = []; }
}

@embedded
class PlanExercise {
  String exerciseId   = '';   // safe default — no 'late'
  String exerciseName = '';   // safe default — no 'late'
  String muscleGroup  = '';   // safe default — no 'late'
  int    sets         = 3;    // safe default
  int    reps         = 10;   // safe default
  int    restSeconds  = 90;   // safe default
  String gifUrl       = '';   // safe default

  PlanExercise();
}

@collection
class WorkoutPlan {
  Id id = Isar.autoIncrement;

  // KEY FIX: 'late' removed — default empty string prevents
  // LateInitializationError when templates are read before uid is set
  @Index()
  String uid = '';

  late String name;
  late String description;
  late String difficulty;
  late String goal;
  late int durationWeeks;
  late int daysPerWeek;
  late List<PlanDay> days;
  late DateTime createdAt;
  bool isTemplate = true;
  int currentWeek = 1;
  int currentDay  = 1;

  WorkoutPlan() { days = []; }

  double get progressPercent {
    final totalDays = durationWeeks * daysPerWeek;
    final doneDays  = (currentWeek - 1) * daysPerWeek + currentDay;
    return (doneDays / totalDays).clamp(0.0, 1.0);
  }
}