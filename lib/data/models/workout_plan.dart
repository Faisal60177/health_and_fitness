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
  // FIX: was 'late String exerciseId' — caused LateInitializationError
  // because _planEx() helper never assigned it.
  // Give it a safe default empty string instead.
  String exerciseId = '';         // ← KEY FIX: no 'late', has default
  late String exerciseName;
  late String muscleGroup;
  late int sets;
  late int reps;
  late int restSeconds;
  String gifUrl = '';

  PlanExercise();
}

@collection
class WorkoutPlan {
  Id id = Isar.autoIncrement;

  @Index()
  late String uid;

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
  int currentDay = 1;

  WorkoutPlan() { days = []; }

  double get progressPercent {
    final totalDays = durationWeeks * daysPerWeek;
    final doneDays  = (currentWeek - 1) * daysPerWeek + currentDay;
    return (doneDays / totalDays).clamp(0.0, 1.0);
  }
}