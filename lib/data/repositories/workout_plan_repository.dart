import 'package:isar/isar.dart';
import '../models/workout_plan.dart';
import '../services/isar_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutPlanRepository {
  final _db = IsarService.db;

  // Single helper — gets current uid once, used by all methods
  String get _uid =>
      FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

  Future<void> savePlan(WorkoutPlan plan) async {
    // Stamp uid on user's active plans (non-templates)
    // Templates keep uid = '' so all users see them
    if (!plan.isTemplate) {
      plan.uid = _uid;             // ← only user plans get uid stamped
    }
    await _db.writeTxn(() async {
      await _db.workoutPlans.put(plan);
    });
  }

  // Get templates — built-in ones (uid='') are visible to everyone
  Future<List<WorkoutPlan>> getTemplates() async {
    return _db.workoutPlans
        .filter()
        .uidEqualTo('')            // ← built-in templates, shared
        .isTemplateEqualTo(true)
        .findAll();
  }

  // Active plan — only THIS user's plan
  Future<WorkoutPlan?> getActivePlan() async {
    return _db.workoutPlans
        .filter()
        .uidEqualTo(_uid)         // ← only this user's active plan
        .isTemplateEqualTo(false)
        .findFirst();
  }

  // Start a plan: deep-copy template → user's active plan
  Future<void> startPlan(WorkoutPlan template) async {
    final existing = await getActivePlan();
    if (existing != null) {
      await _db.writeTxn(() async {
        await _db.workoutPlans.delete(existing.id);
      });
    }

    // Clone template as a non-template active plan
    final active = WorkoutPlan()
      ..uid           = _uid       // ← stamp uid on user's active plan
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
      ..currentDay    = 1;

    await savePlan(active);
  }

  // Mark current day done — advance to next
  Future<void> advanceDay(WorkoutPlan plan) async {
    final nonRestDays = plan.days.where((d) => !d.isRestDay).length;

    if (plan.currentDay >= nonRestDays) {
      // Advance to next week
      plan.currentDay  = 1;
      plan.currentWeek = plan.currentWeek + 1;
    } else {
      plan.currentDay = plan.currentDay + 1;
    }

    await savePlan(plan);
  }

  Future<void> deletePlan(int id) async {
    await _db.writeTxn(() async {
      await _db.workoutPlans.delete(id);
    });
  }

  // Seed the built-in template library if empty
  // Templates check — templates have uid = '' (shared)
  Future<void> seedTemplatesIfEmpty() async {
    // Check if templates exist (uid = '' means shared template)
    final existingTemplates = await _db.workoutPlans
        .filter()
        .uidEqualTo('') // ← templates have empty uid
        .isTemplateEqualTo(true)
        .findAll();

    if (existingTemplates.isNotEmpty) return;

    final templates = _buildTemplates();
    // Templates are seeded with uid = '' (Dart default for String)
    // This means every user sees the same built-in templates
    await _db.writeTxn(() async {
      await _db.workoutPlans.putAll(templates);
    });
  }


  // Built-in workout plan templates
  List<WorkoutPlan> _buildTemplates() {
    return [
      _beginnerFullBody(),
      _intermediateUpperLower(),
      _advancedPPL(),
      _fatLossCardio(),
    ];
  }

  WorkoutPlan _beginnerFullBody() {
    final plan = WorkoutPlan()
      ..name          = 'Beginner Full Body'
      ..description   = 'Perfect for those new to the gym. 3 days/week, full body each session.'
      ..difficulty    = 'beginner'
      ..goal          = 'strength'
      ..durationWeeks = 8
      ..daysPerWeek   = 3
      ..createdAt     = DateTime.now()
      ..isTemplate    = true;

    plan.days = [
      _buildDay(1, 'Monday — Full Body A', false, [
        _planEx('Squat', 'Legs', 3, 8),
        _planEx('Bench Press', 'Chest', 3, 8),
        _planEx('Bent Over Row', 'Back', 3, 8),
        _planEx('Overhead Press', 'Shoulders', 3, 8),
        _planEx('Plank', 'Core', 3, 30),
      ]),
      _buildDay(2, 'Tuesday — Rest', true, []),
      _buildDay(3, 'Wednesday — Full Body B', false, [
        _planEx('Deadlift', 'Back', 3, 5),
        _planEx('Incline Dumbbell Press', 'Chest', 3, 10),
        _planEx('Pull-up', 'Back', 3, 6),
        _planEx('Lateral Raise', 'Shoulders', 3, 12),
        _planEx('Bicycle Crunch', 'Core', 3, 15),
      ]),
      _buildDay(4, 'Thursday — Rest', true, []),
      _buildDay(5, 'Friday — Full Body A', false, [
        _planEx('Squat', 'Legs', 3, 10),
        _planEx('Bench Press', 'Chest', 3, 10),
        _planEx('Bent Over Row', 'Back', 3, 10),
        _planEx('Overhead Press', 'Shoulders', 3, 10),
        _planEx('Plank', 'Core', 3, 45),
      ]),
      _buildDay(6, 'Saturday — Active Recovery', true, []),
      _buildDay(7, 'Sunday — Rest', true, []),
    ];

    return plan;
  }

  WorkoutPlan _intermediateUpperLower() {
    final plan = WorkoutPlan()
      ..name          = 'Upper / Lower Split'
      ..description   = '4-day split alternating upper and lower body. Intermediate level.'
      ..difficulty    = 'intermediate'
      ..goal          = 'strength'
      ..durationWeeks = 12
      ..daysPerWeek   = 4
      ..createdAt     = DateTime.now()
      ..isTemplate    = true;

    plan.days = [
      _buildDay(1, 'Monday — Upper A', false, [
        _planEx('Bench Press', 'Chest', 4, 6),
        _planEx('Barbell Row', 'Back', 4, 6),
        _planEx('Overhead Press', 'Shoulders', 3, 8),
        _planEx('Pull-up', 'Back', 3, 8),
        _planEx('Tricep Dip', 'Arms', 3, 10),
        _planEx('Bicep Curl', 'Arms', 3, 10),
      ]),
      _buildDay(2, 'Tuesday — Lower A', false, [
        _planEx('Squat', 'Legs', 4, 6),
        _planEx('Romanian Deadlift', 'Legs', 3, 10),
        _planEx('Leg Press', 'Legs', 3, 12),
        _planEx('Calf Raise', 'Legs', 4, 15),
        _planEx('Plank', 'Core', 3, 60),
      ]),
      _buildDay(3, 'Wednesday — Rest', true, []),
      _buildDay(4, 'Thursday — Upper B', false, [
        _planEx('Incline Bench Press', 'Chest', 4, 10),
        _planEx('Seated Row', 'Back', 4, 10),
        _planEx('Dumbbell Shoulder Press', 'Shoulders', 3, 12),
        _planEx('Lat Pulldown', 'Back', 3, 12),
        _planEx('Skull Crusher', 'Arms', 3, 12),
        _planEx('Hammer Curl', 'Arms', 3, 12),
      ]),
      _buildDay(5, 'Friday — Lower B', false, [
        _planEx('Deadlift', 'Back', 4, 4),
        _planEx('Bulgarian Split Squat', 'Legs', 3, 10),
        _planEx('Leg Curl', 'Legs', 3, 12),
        _planEx('Standing Calf Raise', 'Legs', 4, 20),
        _planEx('Hanging Leg Raise', 'Core', 3, 12),
      ]),
      _buildDay(6, 'Saturday — Rest', true, []),
      _buildDay(7, 'Sunday — Rest', true, []),
    ];

    return plan;
  }

  WorkoutPlan _advancedPPL() {
    final plan = WorkoutPlan()
      ..name          = 'Push Pull Legs (PPL)'
      ..description   = '6-day PPL program for advanced lifters. High volume, high frequency.'
      ..difficulty    = 'advanced'
      ..goal          = 'strength'
      ..durationWeeks = 16
      ..daysPerWeek   = 6
      ..createdAt     = DateTime.now()
      ..isTemplate    = true;

    plan.days = [
      _buildDay(1, 'Monday — Push', false, [
        _planEx('Bench Press', 'Chest', 5, 5),
        _planEx('Overhead Press', 'Shoulders', 4, 8),
        _planEx('Incline Dumbbell Press', 'Chest', 3, 10),
        _planEx('Lateral Raise', 'Shoulders', 4, 15),
        _planEx('Tricep Pushdown', 'Arms', 3, 12),
        _planEx('Overhead Tricep Extension', 'Arms', 3, 12),
      ]),
      _buildDay(2, 'Tuesday — Pull', false, [
        _planEx('Deadlift', 'Back', 4, 4),
        _planEx('Pull-up', 'Back', 4, 6),
        _planEx('Barbell Row', 'Back', 3, 8),
        _planEx('Face Pull', 'Shoulders', 4, 15),
        _planEx('Bicep Curl', 'Arms', 3, 12),
        _planEx('Hammer Curl', 'Arms', 3, 12),
      ]),
      _buildDay(3, 'Wednesday — Legs', false, [
        _planEx('Squat', 'Legs', 5, 5),
        _planEx('Romanian Deadlift', 'Legs', 4, 10),
        _planEx('Leg Press', 'Legs', 3, 12),
        _planEx('Leg Curl', 'Legs', 3, 12),
        _planEx('Standing Calf Raise', 'Legs', 5, 15),
        _planEx('Hanging Leg Raise', 'Core', 3, 15),
      ]),
      _buildDay(4, 'Thursday — Push (volume)', false, [
        _planEx('Incline Bench Press', 'Chest', 4, 10),
        _planEx('Dumbbell Shoulder Press', 'Shoulders', 4, 10),
        _planEx('Cable Fly', 'Chest', 3, 15),
        _planEx('Lateral Raise', 'Shoulders', 4, 15),
        _planEx('Tricep Dip', 'Arms', 3, 15),
      ]),
      _buildDay(5, 'Friday — Pull (volume)', false, [
        _planEx('Lat Pulldown', 'Back', 4, 10),
        _planEx('Seated Row', 'Back', 4, 10),
        _planEx('Single Arm Row', 'Back', 3, 12),
        _planEx('Reverse Fly', 'Shoulders', 3, 15),
        _planEx('Preacher Curl', 'Arms', 3, 12),
      ]),
      _buildDay(6, 'Saturday — Legs (volume)', false, [
        _planEx('Front Squat', 'Legs', 4, 8),
        _planEx('Hack Squat', 'Legs', 3, 10),
        _planEx('Leg Extension', 'Legs', 3, 15),
        _planEx('Seated Leg Curl', 'Legs', 3, 15),
        _planEx('Seated Calf Raise', 'Legs', 4, 20),
        _planEx('Plank', 'Core', 3, 60),
      ]),
      _buildDay(7, 'Sunday — Rest', true, []),
    ];

    return plan;
  }

  WorkoutPlan _fatLossCardio() {
    final plan = WorkoutPlan()
      ..name          = 'Fat Loss Circuit'
      ..description   = 'High-intensity circuit training 5 days/week to maximize calorie burn.'
      ..difficulty    = 'intermediate'
      ..goal          = 'fat_loss'
      ..durationWeeks = 8
      ..daysPerWeek   = 5
      ..createdAt     = DateTime.now()
      ..isTemplate    = true;

    plan.days = [
      _buildDay(1, 'Monday — Upper Circuit', false, [
        _planEx('Push-up', 'Chest', 4, 15),
        _planEx('Pull-up', 'Back', 3, 8),
        _planEx('Dumbbell Shoulder Press', 'Shoulders', 3, 12),
        _planEx('Bicep Curl', 'Arms', 3, 12),
        _planEx('Tricep Dip', 'Arms', 3, 12),
        _planEx('Burpee', 'Cardio', 3, 10),
      ]),
      _buildDay(2, 'Tuesday — Lower Circuit', false, [
        _planEx('Jump Squat', 'Legs', 4, 15),
        _planEx('Lunge', 'Legs', 3, 12),
        _planEx('Glute Bridge', 'Legs', 3, 15),
        _planEx('Calf Raise', 'Legs', 3, 20),
        _planEx('Mountain Climber', 'Core', 3, 20),
      ]),
      _buildDay(3, 'Wednesday — HIIT Cardio', false, [
        _planEx('High Knees', 'Cardio', 5, 20),
        _planEx('Jump Rope', 'Cardio', 5, 30),
        _planEx('Box Jump', 'Cardio', 4, 10),
        _planEx('Burpee', 'Cardio', 4, 10),
        _planEx('Plank', 'Core', 3, 45),
      ]),
      _buildDay(4, 'Thursday — Full Body Circuit', false, [
        _planEx('Squat to Press', 'Full Body', 4, 12),
        _planEx('Renegade Row', 'Back', 3, 10),
        _planEx('Jump Lunge', 'Legs', 3, 12),
        _planEx('Push-up', 'Chest', 3, 15),
        _planEx('Russian Twist', 'Core', 3, 20),
        _planEx('Burpee', 'Cardio', 3, 8),
      ]),
      _buildDay(5, 'Friday — Metabolic Conditioning', false, [
        _planEx('Deadlift', 'Back', 4, 8),
        _planEx('Bench Press', 'Chest', 4, 10),
        _planEx('Goblet Squat', 'Legs', 4, 12),
        _planEx('Bent Over Row', 'Back', 3, 10),
        _planEx('Plank', 'Core', 3, 60),
      ]),
      _buildDay(6, 'Saturday — Active Recovery', true, []),
      _buildDay(7, 'Sunday — Rest', true, []),
    ];

    return plan;
  }

  PlanDay _buildDay(int num, String label, bool isRest,
      List<PlanExercise> exercises) {
    return PlanDay()
      ..dayNumber  = num
      ..dayLabel   = label
      ..isRestDay  = isRest
      ..exercises  = exercises;
  }

  PlanExercise _planEx(String name, String muscle, int sets, int reps) {
    return PlanExercise()
      ..exerciseName = name
      ..muscleGroup  = muscle
      ..sets         = sets
      ..reps         = reps
      ..restSeconds  = 90;
  }
}