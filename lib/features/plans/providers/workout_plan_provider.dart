import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/workout_plan.dart';
import '../../../data/repositories/workout_plan_repository.dart';

part 'workout_plan_provider.g.dart';

@riverpod
class WorkoutPlanNotifier extends _$WorkoutPlanNotifier {
  final _repo = WorkoutPlanRepository();

  @override
  Future<List<WorkoutPlan>> build() async {
    // Seed built-in templates on first launch
    await _repo.seedTemplatesIfEmpty();
    return _repo.getTemplates();
  }

  Future<void> startPlan(WorkoutPlan template) async {
    await _repo.startPlan(template);
    ref.invalidateSelf();
    ref.invalidate(activePlanProvider); // ADD THIS
  }
}

// Active plan provider — what the user is currently following
@riverpod
Future<WorkoutPlan?> activePlan(Ref ref) async {
  return WorkoutPlanRepository().getActivePlan();
}





