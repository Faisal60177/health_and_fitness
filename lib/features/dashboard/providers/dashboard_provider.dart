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

// ─── Badge Model ─────────────────────────────────────────────────────────────

class AppBadge {
  final String emoji;
  final String title;
  final String desc;
  final bool unlocked;

  const AppBadge({
    required this.emoji,
    required this.title,
    required this.desc,
    required this.unlocked,
  });
}

// ─── Dashboard Summary ────────────────────────────────────────────────────────

class DashboardSummary {
  final int todaySteps;
  final int stepGoal;
  final double todayCalories;
  final double calorieGoal;
  final int todayWaterMl;
  final int waterGoalMl;
  final double? latestWeightKg;
  final int workoutsThisWeek;
  final double? lastSleepHours;
  final int currentStreak;
  final List<AppBadge> badges;

  const DashboardSummary({
    this.todaySteps = 0,
    this.stepGoal = 10000,
    this.todayCalories = 0,
    this.calorieGoal = 2000,
    this.todayWaterMl = 0,
    this.waterGoalMl = 2500,
    this.latestWeightKg,
    this.workoutsThisWeek = 0,
    this.lastSleepHours,
    this.currentStreak = 0,
    this.badges = const [],
  });

  double get stepProgress => (todaySteps / stepGoal).clamp(0.0, 1.0);
  double get calorieProgress => (todayCalories / calorieGoal).clamp(0.0, 1.0);
  double get waterProgress => (todayWaterMl / waterGoalMl).clamp(0.0, 1.0);
}

// ─── Badge Logic (pure function, fully testable) ──────────────────────────────

List<AppBadge> _buildBadges({
  required int todaySteps,
  required double waterProgress,
  required double stepProgress,
  required int currentStreak,
  required int workoutsThisWeek,
  required double? lastSleepHours,
}) {
  return [
    AppBadge(
      emoji: '👟',
      title: 'First Steps',
      desc: 'Log your first day of steps',
      unlocked: todaySteps > 0,
    ),
    AppBadge(
      emoji: '🔥',
      title: '3-Day Streak',
      desc: 'Stay active 3 days in a row',
      unlocked: currentStreak >= 3,
    ),
    AppBadge(
      emoji: '💧',
      title: 'Hydrated',
      desc: 'Reach daily water goal',
      unlocked: waterProgress >= 1.0,
    ),
    AppBadge(
      emoji: '🏋️',
      title: 'Iron Will',
      desc: 'Complete 5 workouts in a week',
      unlocked: workoutsThisWeek >= 5,
    ),
    AppBadge(
      emoji: '🎯',
      title: 'Step Master',
      desc: 'Reach 10,000 steps in a day',
      unlocked: stepProgress >= 1.0,
    ),
    AppBadge(
      emoji: '🌙',
      title: 'Sleep Champion',
      desc: 'Get 8+ hours of sleep',
      unlocked: (lastSleepHours ?? 0) >= 8,
    ),
  ];
}

// ─── Provider ─────────────────────────────────────────────────────────────────

@riverpod
Future<DashboardSummary> dashboardSummary(Ref ref) async {
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

  final stepEntry = results[0] as StepEntry?;
  final foodSummary = results[1] as Map<String, double>;
  final waterMl = results[2] as int;
  final weightLog = results[3] as WeightLog?;
  final sleepLogs = results[5] as List;
  final streak = results[6] as int;

  final allSessions = await WorkoutRepository().getAllSessions();
  final weekStart = DateTime.now().subtract(const Duration(days: 7));
  final weeklyWorkouts =
  allSessions.where((s) => s.date.isAfter(weekStart)).toList();

  final todaySteps = stepEntry?.stepCount ?? 0;
  final todayWaterMl = waterMl;
  final todayCalories = foodSummary['calories'] ?? 0;
  final lastSleepHours =
  sleepLogs.isEmpty ? null : (sleepLogs.first as dynamic).durationHours as double?;

  // Compute progress values needed for badges
  final stepProgress =
  (todaySteps / goals.dailyStepGoal).clamp(0.0, 1.0);
  final waterProgress =
  (todayWaterMl / goals.dailyWaterMl).clamp(0.0, 1.0);

  final badges = _buildBadges(
    todaySteps: todaySteps,
    waterProgress: waterProgress,
    stepProgress: stepProgress,
    currentStreak: streak,
    workoutsThisWeek: weeklyWorkouts.length,
    lastSleepHours: lastSleepHours,
  );

  return DashboardSummary(
    todaySteps: todaySteps,
    stepGoal: goals.dailyStepGoal,
    todayCalories: todayCalories,
    calorieGoal: goals.dailyCalorieTarget.toDouble(),
    todayWaterMl: todayWaterMl,
    waterGoalMl: goals.dailyWaterMl,
    latestWeightKg: weightLog?.weightKg,
    workoutsThisWeek: weeklyWorkouts.length,
    lastSleepHours: lastSleepHours,
    currentStreak: streak,
    badges: badges,
  );
}

// ─── Streak Calculator ────────────────────────────────────────────────────────

Future<int> _calculateStreak() async {
  int streak = 0;
  final goals = await UserGoalsRepository().getGoals();
  final stepLogs = await StepRepository().getRecentDays(365);

  final stepMap = <String, int>{};
  for (final e in stepLogs) {
    final key = '${e.date.year}-${e.date.month}-${e.date.day}';
    stepMap[key] = e.stepCount;
  }

  DateTime day = DateTime.now();
  for (int i = 0; i < 365; i++) {
    final key = '${day.year}-${day.month}-${day.day}';
    final steps = stepMap[key] ?? 0;
    final hasActivity = steps > (goals.dailyStepGoal * 0.5);
    if (!hasActivity && i > 0) break;
    if (hasActivity) streak++;
    day = day.subtract(const Duration(days: 1));
  }
  return streak;
}