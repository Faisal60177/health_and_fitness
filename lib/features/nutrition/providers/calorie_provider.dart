import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/food_log.dart';
import '../../../data/models/user_goals.dart';
import '../../../data/repositories/food_repository.dart';
import '../../../data/repositories/user_goals_repository.dart';

part 'calorie_provider.g.dart';

class NutritionState {
  final List<FoodLog> logs;
  final double calorieGoal;  // now from UserGoals

  const NutritionState({
    this.logs        = const [],
    this.calorieGoal = 2000,
  });

  double get totalCalories    => logs.fold(0.0, (s, f) => s + f.calories);
  double get totalProtein     => logs.fold(0.0, (s, f) => s + f.proteinG);
  double get totalCarbs       => logs.fold(0.0, (s, f) => s + f.carbsG);
  double get totalFat         => logs.fold(0.0, (s, f) => s + f.fatG);
  double get remainingCalories =>
      (calorieGoal - totalCalories).clamp(0.0, calorieGoal);
  double get calorieProgress  =>
      (totalCalories / calorieGoal).clamp(0.0, 1.0);
  bool   get goalReached      => totalCalories >= calorieGoal;

  Map<MealType, List<FoodLog>> get byMeal {
    final map = <MealType, List<FoodLog>>{};
    for (final log in logs) {
      map.putIfAbsent(log.mealType, () => []).add(log);
    }
    return map;
  }
}

@riverpod
class CalorieNotifier extends _$CalorieNotifier {
  final _repo      = FoodRepository();
  final _goalsRepo = UserGoalsRepository();

  @override
  Future<NutritionState> build() async {
    final results = await Future.wait([
      _repo.getLogsForDate(DateTime.now()),
      _goalsRepo.getGoals(),
    ]);

    final logs  = results[0] as List<FoodLog>;
    final goals = results[1] as UserGoals;

    return NutritionState(
      logs:        logs,
      calorieGoal: goals.dailyCalorieTarget.toDouble(), // from UserGoals
    );
  }

  Future<void> logFood(FoodLog entry) async {
    await _repo.logFood(entry);
    ref.invalidateSelf();
    await future;
  }

  Future<void> deleteLog(int id) async {
    await _repo.deleteLog(id);
    ref.invalidateSelf();
    await future;
  }

  Future<void> updateGoal(double newGoal) async {
    final goals = await _goalsRepo.getGoals();
    goals.dailyCalorieTarget = newGoal.toInt();
    await _goalsRepo.saveGoals(goals);
    ref.invalidateSelf();
    await future;
  }
}



