import 'dart:convert';
import 'package:objectbox/objectbox.dart';


// Not an @Entity — stored as JSON string inside WorkoutSession
class WorkoutSet {
  double weightKg;
  int    reps;
  int    durationSeconds;
  bool   isCompleted;

  WorkoutSet({
    this.weightKg       = 0,
    this.reps           = 0,
    this.durationSeconds = 0,
    this.isCompleted    = false,
  });

  factory WorkoutSet.create({
    double weightKg = 0,
    int reps = 0,
    int durationSeconds = 0,
  }) => WorkoutSet(
    weightKg: weightKg, reps: reps,
    durationSeconds: durationSeconds,
  );

  Map<String, dynamic> toJson() => {
    'weightKg': weightKg, 'reps': reps,
    'durationSeconds': durationSeconds,
    'isCompleted': isCompleted,
  };

  factory WorkoutSet.fromJson(Map<String, dynamic> j) => WorkoutSet(
    weightKg:        (j['weightKg']        as num).toDouble(),
    reps:            j['reps']             as int,
    durationSeconds: j['durationSeconds']  as int,
    isCompleted:     j['isCompleted']      as bool,
  );
}

class WorkoutExercise {
  String name;
  String muscleGroup;
  List<WorkoutSet> sets;

  WorkoutExercise({
    required this.name,
    required this.muscleGroup,
    List<WorkoutSet>? sets,
  }) : sets = sets ?? [];

  double get totalVolume =>
      sets.fold(0.0, (s, set) => s + (set.weightKg * set.reps));

  Map<String, dynamic> toJson() => {
    'name': name, 'muscleGroup': muscleGroup,
    'sets': sets.map((s) => s.toJson()).toList(),
  };

  factory WorkoutExercise.fromJson(Map<String, dynamic> j) =>
      WorkoutExercise(
        name:        j['name']        as String,
        muscleGroup: j['muscleGroup'] as String,
        sets: (j['sets'] as List)
            .map((s) => WorkoutSet.fromJson(s as Map<String, dynamic>))
            .toList(),
      );
}

@Entity()
class WorkoutSession {
  int id = 0;

  @Index()
  String uid = '';

  late String   name;
  @Property(type: PropertyType.date)
  late DateTime date;
  late int      durationMinutes;
  String notes = '';

  // Exercises stored as JSON string
  String exercisesJson = '[]';

  List<WorkoutExercise> get exercises {
    final list = jsonDecode(exercisesJson) as List;
    return list
        .map((e) => WorkoutExercise.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  set exercises(List<WorkoutExercise> value) {
    exercisesJson = jsonEncode(value.map((e) => e.toJson()).toList());
  }

  int    get totalSets   => exercises.fold(0,   (s, ex) => s + ex.sets.length);
  double get totalVolume => exercises.fold(0.0, (s, ex) => s + ex.totalVolume);
}





