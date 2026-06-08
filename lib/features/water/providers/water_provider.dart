import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/water_log.dart';
import '../../../data/models/user_goals.dart';
import '../../../data/repositories/water_repository.dart';
import '../../../data/repositories/user_goals_repository.dart';
import 'package:health_and_fitness/data/services/notification_service.dart';

part 'water_provider.g.dart';

class WaterState {
  final List<WaterLog> logs;
  final int dailyGoalMl;    // now loaded from UserGoals, not hardcoded

  const WaterState({
    this.logs        = const [],
    this.dailyGoalMl = 2500,
  });

  int    get totalMl   => logs.fold<int>(0, (s, l) => s + l.amountML);
  double get progress  => (totalMl / dailyGoalMl).clamp(0.0, 1.0);
  double get glasses   => totalMl / 250;
  double get goalGlasses => dailyGoalMl / 250;
  bool   get goalReached => totalMl >= dailyGoalMl;
}

@riverpod
class WaterNotifier extends _$WaterNotifier {
  final _repo      = WaterRepository();
  final _goalsRepo = UserGoalsRepository();

  @override
  Future<WaterState> build() async {
    // Load both logs AND the user's custom goal simultaneously
    final results = await Future.wait([
      _repo.getTodayLogs(),
      _goalsRepo.getGoals(),
    ]);

    final logs  = results[0] as List<WaterLog>;
    final goals = results[1] as UserGoals;

    return WaterState(
      logs:        logs,
      dailyGoalMl: goals.dailyWaterMl,  // reads from UserGoals not hardcoded
    );
  }

  Future<void> addWater(int amountMl) async {
    await _repo.logWater(amountMl);
    ref.invalidateSelf();
    final newState = await future;

    // Check if goal just reached — trigger completion notification
    if (newState.goalReached) {
      await _checkAndNotifyWaterGoal();
    }
  }

  Future<void> deleteLog(int id) async {
    await _repo.deleteLog(id);
    ref.invalidateSelf();
    await future;
  }

  Future<void> updateGoal(int newGoalMl) async {
    await _goalsRepo.saveGoals(
      (await _goalsRepo.getGoals())..dailyWaterMl = newGoalMl,
    );
    ref.invalidateSelf();
    await future;
  }

  Future<void> _checkAndNotifyWaterGoal() async {
    await NotificationService.showInstant(
      id:    NotificationIds.water,
      title: '💧 Water goal reached!',
      body:  'You\'ve hit your daily water target. Well done!',
    );
  }
}




