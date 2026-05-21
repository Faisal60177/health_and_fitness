import 'package:isar/isar.dart';

part 'workout_log.g.dart';

// Represents ONE exercise set inside a workout session
// Example: Bench Press — Set 1: 80kg × 10 reps
@embedded  // embedded = stored inside WorkoutSession, not as its own collection
class WorkoutSet {
  late double weightKg;
  late int reps;
  late int durationSeconds; // for timed exercises like planks
  late bool isCompleted;

  WorkoutSet();

  // Factory constructor for clean creation
  factory WorkoutSet.create({
    double weightKg = 0,
    int reps = 0,
    int durationSeconds = 0,
  }) {
    return WorkoutSet()
      ..weightKg = weightKg
      ..reps = reps
      ..durationSeconds = durationSeconds
      ..isCompleted = false;
  }
}

// Represents ONE exercise with multiple sets
// Example: Bench Press — 3 sets
@embedded
class WorkoutExercise {
  late String name;          // "Bench Press"
  late String muscleGroup;   // "Chest"
  late List<WorkoutSet> sets;

  WorkoutExercise() {
    sets = [];
  }

  // Total volume = sum of (weight × reps) for all sets
  // This is the key metric for strength progress tracking
  double get totalVolume => sets.fold(
    0.0,
        (sum, set) => sum + (set.weightKg * set.reps),
  );
}

// Represents ONE complete workout session
// Example: "Monday Push Day" — 5 exercises, 45 minutes
@collection
class WorkoutSession {
  Id id = Isar.autoIncrement;

  @Index()
  late String uid;

  late String name;                    // "Push Day", "Leg Day"
  late DateTime date;
  late int durationMinutes;
  late List<WorkoutExercise> exercises;
  String notes = '';

  WorkoutSession() {
    exercises = [];
  }

  // Total sets across all exercises
  int get totalSets =>
      exercises.fold(0, (sum, ex) => sum + ex.sets.length);

  // Total volume lifted in this session
  double get totalVolume =>
      exercises.fold(0.0, (sum, ex) => sum + ex.totalVolume);
}