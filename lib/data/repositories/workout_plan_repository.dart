import 'package:health_and_fitness/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import '../models/workout_plan.dart';
import '../services/objectbox_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutPlanRepository {
  Box<WorkoutPlan> get _box => ObjectBoxService.workoutPlans;

  String get _uid =>
      FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

  Future<void> savePlan(WorkoutPlan plan) async {
    if (!plan.isTemplate) plan.uid = _uid;
    _box.put(plan);
  }

  Future<List<WorkoutPlan>> getTemplates() async {
    return _box.query(
      WorkoutPlan_.uid.equals('')
          .and(WorkoutPlan_.isTemplate.equals(true)),
    ).build().find();
  }

  Future<WorkoutPlan?> getActivePlan() async {
    return _box.query(
      WorkoutPlan_.uid.equals(_uid)
          .and(WorkoutPlan_.isTemplate.equals(false)),
    ).build().findFirst();
  }

  Future<void> startPlan(WorkoutPlan template) async {
    final existing = await getActivePlan();
    if (existing != null) _box.remove(existing.id);

    _box.put(WorkoutPlan()
      ..uid           = _uid
      ..name          = template.name
      ..description   = template.description
      ..difficulty    = template.difficulty
      ..goal          = template.goal
      ..durationWeeks = template.durationWeeks
      ..daysPerWeek   = template.daysPerWeek
      ..days          = template.days
      ..createdAt     = DateTime.now()
      ..isTemplate    = false
      ..currentWeek   = 1
      ..currentDay    = 1);
  }

  Future<void> advanceDay(WorkoutPlan plan) async {
    final nonRestDays = plan.days.where((d) => !d.isRestDay).length;
    if (plan.currentDay >= nonRestDays) {
      plan.currentDay  = 1;
      plan.currentWeek = plan.currentWeek + 1;
    } else {
      plan.currentDay = plan.currentDay + 1;
    }
    await savePlan(plan);
  }

  Future<void> deletePlan(int id) async {
    _box.remove(id);
  }

  Future<void> seedTemplatesIfEmpty() async {
    final existing = _box.query(
      WorkoutPlan_.uid.equals('')
          .and(WorkoutPlan_.isTemplate.equals(true)),
    ).build().find();
    if (existing.isNotEmpty) return;
    _box.putMany(_buildTemplates());
  }

  List<WorkoutPlan> _buildTemplates() => [
    _beginnerFullBody(),
    _intermediateUpperLower(),
    _advancedPPL(),
    _fatLossCardio(),
  ];

  WorkoutPlan _beginnerFullBody() {
    final plan = WorkoutPlan()
      ..name = 'Beginner Full Body'
      ..description = 'Perfect for those new to the gym. 3 days/week, full body each session.'
      ..difficulty = 'beginner' ..goal = 'strength'
      ..durationWeeks = 8 ..daysPerWeek = 3
      ..createdAt = DateTime.now() ..isTemplate = true;
    plan.days = [
      _day(1, 'Monday — Full Body A', false, [
        _ex('Squat','Legs',3,8), _ex('Bench Press','Chest',3,8),
        _ex('Bent Over Row','Back',3,8), _ex('Overhead Press','Shoulders',3,8),
        _ex('Plank','Core',3,30),
      ]),
      _day(2, 'Tuesday — Rest', true, []),
      _day(3, 'Wednesday — Full Body B', false, [
        _ex('Deadlift','Back',3,5), _ex('Incline Dumbbell Press','Chest',3,10),
        _ex('Pull-up','Back',3,6), _ex('Lateral Raise','Shoulders',3,12),
        _ex('Bicycle Crunch','Core',3,15),
      ]),
      _day(4, 'Thursday — Rest', true, []),
      _day(5, 'Friday — Full Body A', false, [
        _ex('Squat','Legs',3,10), _ex('Bench Press','Chest',3,10),
        _ex('Bent Over Row','Back',3,10), _ex('Overhead Press','Shoulders',3,10),
        _ex('Plank','Core',3,45),
      ]),
      _day(6, 'Saturday — Active Recovery', true, []),
      _day(7, 'Sunday — Rest', true, []),
    ];
    return plan;
  }

  WorkoutPlan _intermediateUpperLower() {
    final plan = WorkoutPlan()
      ..name = 'Upper / Lower Split'
      ..description = '4-day split alternating upper and lower body. Intermediate level.'
      ..difficulty = 'intermediate' ..goal = 'strength'
      ..durationWeeks = 12 ..daysPerWeek = 4
      ..createdAt = DateTime.now() ..isTemplate = true;
    plan.days = [
      _day(1, 'Monday — Upper A', false, [
        _ex('Bench Press','Chest',4,6), _ex('Barbell Row','Back',4,6),
        _ex('Overhead Press','Shoulders',3,8), _ex('Pull-up','Back',3,8),
        _ex('Tricep Dip','Arms',3,10), _ex('Bicep Curl','Arms',3,10),
      ]),
      _day(2, 'Tuesday — Lower A', false, [
        _ex('Squat','Legs',4,6), _ex('Romanian Deadlift','Legs',3,10),
        _ex('Leg Press','Legs',3,12), _ex('Calf Raise','Legs',4,15),
        _ex('Plank','Core',3,60),
      ]),
      _day(3, 'Wednesday — Rest', true, []),
      _day(4, 'Thursday — Upper B', false, [
        _ex('Incline Bench Press','Chest',4,10), _ex('Seated Row','Back',4,10),
        _ex('Dumbbell Shoulder Press','Shoulders',3,12),
        _ex('Lat Pulldown','Back',3,12), _ex('Skull Crusher','Arms',3,12),
        _ex('Hammer Curl','Arms',3,12),
      ]),
      _day(5, 'Friday — Lower B', false, [
        _ex('Deadlift','Back',4,4), _ex('Bulgarian Split Squat','Legs',3,10),
        _ex('Leg Curl','Legs',3,12), _ex('Standing Calf Raise','Legs',4,20),
        _ex('Hanging Leg Raise','Core',3,12),
      ]),
      _day(6, 'Saturday — Rest', true, []),
      _day(7, 'Sunday — Rest', true, []),
    ];
    return plan;
  }

  WorkoutPlan _advancedPPL() {
    final plan = WorkoutPlan()
      ..name = 'Push Pull Legs (PPL)'
      ..description = '6-day PPL program for advanced lifters. High volume, high frequency.'
      ..difficulty = 'advanced' ..goal = 'strength'
      ..durationWeeks = 16 ..daysPerWeek = 6
      ..createdAt = DateTime.now() ..isTemplate = true;
    plan.days = [
      _day(1, 'Monday — Push', false, [
        _ex('Bench Press','Chest',5,5), _ex('Overhead Press','Shoulders',4,8),
        _ex('Incline Dumbbell Press','Chest',3,10),
        _ex('Lateral Raise','Shoulders',4,15),
        _ex('Tricep Pushdown','Arms',3,12),
        _ex('Overhead Tricep Extension','Arms',3,12),
      ]),
      _day(2, 'Tuesday — Pull', false, [
        _ex('Deadlift','Back',4,4), _ex('Pull-up','Back',4,6),
        _ex('Barbell Row','Back',3,8), _ex('Face Pull','Shoulders',4,15),
        _ex('Bicep Curl','Arms',3,12), _ex('Hammer Curl','Arms',3,12),
      ]),
      _day(3, 'Wednesday — Legs', false, [
        _ex('Squat','Legs',5,5), _ex('Romanian Deadlift','Legs',4,10),
        _ex('Leg Press','Legs',3,12), _ex('Leg Curl','Legs',3,12),
        _ex('Standing Calf Raise','Legs',5,15),
        _ex('Hanging Leg Raise','Core',3,15),
      ]),
      _day(4, 'Thursday — Push (volume)', false, [
        _ex('Incline Bench Press','Chest',4,10),
        _ex('Dumbbell Shoulder Press','Shoulders',4,10),
        _ex('Cable Fly','Chest',3,15), _ex('Lateral Raise','Shoulders',4,15),
        _ex('Tricep Dip','Arms',3,15),
      ]),
      _day(5, 'Friday — Pull (volume)', false, [
        _ex('Lat Pulldown','Back',4,10), _ex('Seated Row','Back',4,10),
        _ex('Single Arm Row','Back',3,12), _ex('Reverse Fly','Shoulders',3,15),
        _ex('Preacher Curl','Arms',3,12),
      ]),
      _day(6, 'Saturday — Legs (volume)', false, [
        _ex('Front Squat','Legs',4,8), _ex('Hack Squat','Legs',3,10),
        _ex('Leg Extension','Legs',3,15), _ex('Seated Leg Curl','Legs',3,15),
        _ex('Seated Calf Raise','Legs',4,20), _ex('Plank','Core',3,60),
      ]),
      _day(7, 'Sunday — Rest', true, []),
    ];
    return plan;
  }

  WorkoutPlan _fatLossCardio() {
    final plan = WorkoutPlan()
      ..name = 'Fat Loss Circuit'
      ..description = 'High-intensity circuit training 5 days/week to maximize calorie burn.'
      ..difficulty = 'intermediate' ..goal = 'fat_loss'
      ..durationWeeks = 8 ..daysPerWeek = 5
      ..createdAt = DateTime.now() ..isTemplate = true;
    plan.days = [
      _day(1, 'Monday — Upper Circuit', false, [
        _ex('Push-up','Chest',4,15), _ex('Pull-up','Back',3,8),
        _ex('Dumbbell Shoulder Press','Shoulders',3,12),
        _ex('Bicep Curl','Arms',3,12), _ex('Tricep Dip','Arms',3,12),
        _ex('Burpee','Cardio',3,10),
      ]),
      _day(2, 'Tuesday — Lower Circuit', false, [
        _ex('Jump Squat','Legs',4,15), _ex('Lunge','Legs',3,12),
        _ex('Glute Bridge','Legs',3,15), _ex('Calf Raise','Legs',3,20),
        _ex('Mountain Climber','Core',3,20),
      ]),
      _day(3, 'Wednesday — HIIT Cardio', false, [
        _ex('High Knees','Cardio',5,20), _ex('Jump Rope','Cardio',5,30),
        _ex('Box Jump','Cardio',4,10), _ex('Burpee','Cardio',4,10),
        _ex('Plank','Core',3,45),
      ]),
      _day(4, 'Thursday — Full Body Circuit', false, [
        _ex('Squat to Press','Full Body',4,12),
        _ex('Renegade Row','Back',3,10), _ex('Jump Lunge','Legs',3,12),
        _ex('Push-up','Chest',3,15), _ex('Russian Twist','Core',3,20),
        _ex('Burpee','Cardio',3,8),
      ]),
      _day(5, 'Friday — Metabolic Conditioning', false, [
        _ex('Deadlift','Back',4,8), _ex('Bench Press','Chest',4,10),
        _ex('Goblet Squat','Legs',4,12), _ex('Bent Over Row','Back',3,10),
        _ex('Plank','Core',3,60),
      ]),
      _day(6, 'Saturday — Active Recovery', true, []),
      _day(7, 'Sunday — Rest', true, []),
    ];
    return plan;
  }

  PlanDay _day(int num, String label, bool isRest,
      List<PlanExercise> exercises) =>
      PlanDay()
        ..dayNumber  = num
        ..dayLabel   = label
        ..isRestDay  = isRest
        ..exercises  = exercises;

  PlanExercise _ex(String name, String muscle, int sets, int reps) =>
      PlanExercise()
        ..exerciseName = name
        ..muscleGroup  = muscle
        ..sets         = sets
        ..reps         = reps
        ..restSeconds  = 90;
}




