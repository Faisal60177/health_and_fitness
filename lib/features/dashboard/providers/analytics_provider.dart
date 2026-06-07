import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/repositories/step_repository.dart';
import '../../../data/repositories/food_repository.dart';
import '../../../data/repositories/sleep_repository.dart';
import '../../../data/repositories/weight_repository.dart';
import '../../../data/repositories/workout_repository.dart';
import '../../../data/models/step_entry.dart';
import '../../../data/models/food_log.dart';
import '../../../data/models/sleep_log.dart';
import '../../../data/models/weight_log.dart';
import '../../../data/models/workout_log.dart';

part 'analytics_provider.g.dart';

// The time range the user is viewing
enum AnalyticsRange { week, month }

// All the chart data in one place
class AnalyticsData {
  final List<StepEntry>      stepHistory;
  final List<FoodLog>        foodHistory;
  final List<SleepLog>       sleepHistory;
  final List<WeightLog>      weightHistory;
  final List<WorkoutSession> workoutHistory;  // ✅ added
  final AnalyticsRange       range;

  const AnalyticsData({
    required this.stepHistory,
    required this.foodHistory,
    required this.sleepHistory,
    required this.weightHistory,
    required this.workoutHistory,              // ✅ added
    required this.range,
  });

  // Average steps for the period
  double get avgSteps {
    if (stepHistory.isEmpty) return 0;
    return stepHistory.fold(0.0, (s, e) => s + e.stepCount) / stepHistory.length;
  }

  // Average calories for the period
  double get avgCalories {
    if (foodHistory.isEmpty) return 0;
    final byDay = <String, double>{};
    for (final f in foodHistory) {
      final key = '${f.date.year}-${f.date.month}-${f.date.day}';
      byDay[key] = (byDay[key] ?? 0) + f.calories;
    }
    return byDay.values.fold(0.0, (s, v) => s + v) / byDay.length;
  }

  // Average sleep hours
  double get avgSleep {
    if (sleepHistory.isEmpty) return 0;
    return sleepHistory.fold(0.0, (s, l) => s + l.durationHours)
        / sleepHistory.length;
  }

  // Average workout duration for the period
  double get avgWorkoutDuration {
    if (workoutHistory.isEmpty) return 0;
    return workoutHistory.fold(0.0, (s, w) => s + w.durationMinutes)
        / workoutHistory.length;
  }

  // Total sets across all workouts in the period
  int get totalSets =>
      workoutHistory.fold(0, (s, w) => s + w.totalSets);

  // Total volume (kg × reps) across all workouts in the period
  double get totalVolume =>
      workoutHistory.fold(0.0, (s, w) => s + w.totalVolume);

  // Step data as chart points
  List<Map<String, dynamic>> get stepChartPoints {
    return stepHistory.asMap().entries.map((e) => {
      'x': e.key.toDouble(),
      'y': e.value.stepCount.toDouble(),
      'date': e.value.date,
    }).toList();
  }
}

@riverpod
class AnalyticsNotifier extends _$AnalyticsNotifier {
  @override
  Future<AnalyticsData> build() async {
    return _load(AnalyticsRange.week);
  }

  Future<void> setRange(AnalyticsRange range) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(range));
  }

  Future<AnalyticsData> _load(AnalyticsRange range) async {
    final days = range == AnalyticsRange.week ? 7 : 30;
    final from = DateTime.now().subtract(Duration(days: days));

    final results = await Future.wait([
      StepRepository().getRecentDays(days),
      FoodRepository().getLogsForDate(from),
      SleepRepository().getRecentNights(days),
      WeightRepository().getHistory(),
      WorkoutRepository().getAllSessions(),          // ✅ added
    ]);

    // Filter workouts to the selected date range
    final allWorkouts = results[4] as List<WorkoutSession>;
    final filteredWorkouts = allWorkouts
        .where((w) => w.date.isAfter(from))
        .toList();

    return AnalyticsData(
      stepHistory:    results[0] as List<StepEntry>,
      foodHistory:    results[1] as List<FoodLog>,
      sleepHistory:   results[2] as List<SleepLog>,
      weightHistory:  (results[3] as List<WeightLog>)
          .where((w) => w.date.isAfter(from))
          .toList(),
      workoutHistory: filteredWorkouts,              // ✅ added
      range: range,
    );
  }
}

// Provides the heatmap data — 84 days (12 weeks) grid
// Each cell = activity intensity (0–4) based on step count
@riverpod
Future<Map<DateTime, int>> activityHeatmap(ActivityHeatmapRef ref) async {
  final stepLogs = await StepRepository().getRecentDays(365);
  final map = <DateTime, int>{};

  for (final entry in stepLogs) {
    final day = DateTime(entry.date.year, entry.date.month, entry.date.day);
    // Intensity: 0=none, 1=light(<2500), 2=moderate(<5000), 3=active(<10000), 4=goal reached
    final intensity = entry.stepCount == 0    ? 0
        : entry.stepCount < 2500 ? 1
        : entry.stepCount < 5000 ? 2
        : entry.stepCount < 10000 ? 3
        : 4;
    map[day] = intensity;
  }
  return map;
}