import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/repositories/step_repository.dart';
import '../../../data/repositories/food_repository.dart';
import '../../../data/repositories/water_repository.dart';
import '../../../data/repositories/weight_repository.dart';
import '../../../data/repositories/workout_repository.dart';
import '../../../data/repositories/sleep_repository.dart';
import '../../../data/repositories/user_goals_repository.dart';
import '../../../data/models/step_entry.dart';
import '../../../data/models/weight_log.dart';

part 'dashboard_provider.g.dart';

class DashboardSummary {
  final int    todaySteps;
  final int    stepGoal;           // from UserGoals — not hardcoded
  final double todayCalories;
  final double calorieGoal;        // from UserGoals — not hardcoded
  final int    todayWaterMl;
  final int    waterGoalMl;        // from UserGoals — not hardcoded
  final double? latestWeightKg;
  final int    workoutsThisWeek;
  final double? lastSleepHours;
  final int    currentStreak;

  const DashboardSummary({
    this.todaySteps      = 0,
    this.stepGoal        = 10000,  // default only — overridden from UserGoals
    this.todayCalories   = 0,
    this.calorieGoal     = 2000,
    this.todayWaterMl    = 0,
    this.waterGoalMl     = 2500,
    this.latestWeightKg,
    this.workoutsThisWeek = 0,
    this.lastSleepHours,
    this.currentStreak   = 0,
  });

  // Progress values all use the user's custom goals now
  double get stepProgress    => (todaySteps / stepGoal).clamp(0.0, 1.0);
  double get calorieProgress => (todayCalories / calorieGoal).clamp(0.0, 1.0);
  double get waterProgress   => (todayWaterMl / waterGoalMl).clamp(0.0, 1.0);
}

@riverpod
Future<DashboardSummary> dashboardSummary(DashboardSummaryRef ref) async {
  // Load user's custom goals FIRST — everything else uses them
  final goals = await UserGoalsRepository().getGoals();

  final results = await Future.wait([
    StepRepository().getTodayEntry(),
    FoodRepository().getTodaySummary(),
    WaterRepository().getTodayTotal(),
    WeightRepository().getLatest(),
    WorkoutRepository().getSessionsForDate(DateTime.now()),
    SleepRepository().getRecentNights(1),
    _calculateStreak(),
  ]);

  final stepEntry     = results[0] as StepEntry?;
  final foodSummary   = results[1] as Map<String, double>;
  final waterMl       = results[2] as int;
  final weightLog     = results[3] as WeightLog?;
  final sleepLogs     = results[5] as List;
  final streak        = results[6] as int;

  final weeklyWorkouts = await WorkoutRepository()
      .getSessionsForDate(
      DateTime.now().subtract(const Duration(days: 7)));

  return DashboardSummary(
    todaySteps:       stepEntry?.stepCount ?? 0,
    stepGoal:         goals.dailyStepGoal,       // ← from UserGoals
    todayCalories:    foodSummary['calories'] ?? 0,
    calorieGoal:      goals.dailyCalorieTarget.toDouble(), // ← from UserGoals
    todayWaterMl:     waterMl,
    waterGoalMl:      goals.dailyWaterMl,        // ← from UserGoals
    latestWeightKg:   weightLog?.weightKg,
    workoutsThisWeek: weeklyWorkouts.length,
    lastSleepHours:   sleepLogs.isEmpty
        ? null
        : (sleepLogs.first as dynamic).durationHours,
    currentStreak:    streak,
  );
}

Future<int> _calculateStreak() async {
  int streak = 0;
  DateTime day = DateTime.now();
  final goals = await UserGoalsRepository().getGoals();

  for (int i = 0; i < 365; i++) {
    final check     = DateTime(day.year, day.month, day.day);
    final steps     = await StepRepository().getTodayEntry();
    // Use user's own goal threshold for streak calculation
    final hasActivity =
        (steps?.stepCount ?? 0) > (goals.dailyStepGoal * 0.5);
    if (!hasActivity && i > 0) break;
    if (hasActivity) streak++;
    day = day.subtract(const Duration(days: 1));
  }
  return streak;
}