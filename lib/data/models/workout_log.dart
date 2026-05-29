import 'package:isar/isar.dart';

part 'workout_log.g.dart';

@embedded
class WorkoutSet {
  late double weightKg;
  late int reps;
  late int durationSeconds;
  late bool isCompleted;

  WorkoutSet();

  factory WorkoutSet.create({
    double weightKg = 0,
    int reps = 0,
    int durationSeconds = 0,
  }) {
    return WorkoutSet()
      ..weightKg        = weightKg
      ..reps            = reps
      ..durationSeconds = durationSeconds
      ..isCompleted     = false;
  }
}

@embedded
class WorkoutExercise {
  late String name;
  late String muscleGroup;
  late List<WorkoutSet> sets;

  WorkoutExercise() { sets = []; }

  double get totalVolume =>
      sets.fold(0.0, (sum, set) => sum + (set.weightKg * set.reps));
}

@collection
class WorkoutSession {
  Id id = Isar.autoIncrement;

  // FIX: was 'late String uid'
  @Index()
  String uid = '';

  late String name;
  late DateTime date;
  late int durationMinutes;
  late List<WorkoutExercise> exercises;
  String notes = '';

  WorkoutSession() { exercises = []; }

  int    get totalSets   => exercises.fold(0,   (sum, ex) => sum + ex.sets.length);
  double get totalVolume => exercises.fold(0.0, (sum, ex) => sum + ex.totalVolume);
}