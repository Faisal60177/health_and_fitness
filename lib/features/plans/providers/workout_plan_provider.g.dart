// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_plan_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WorkoutPlanNotifier)
final workoutPlanProvider = WorkoutPlanNotifierProvider._();

final class WorkoutPlanNotifierProvider
    extends $AsyncNotifierProvider<WorkoutPlanNotifier, List<WorkoutPlan>> {
  WorkoutPlanNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutPlanProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutPlanNotifierHash();

  @$internal
  @override
  WorkoutPlanNotifier create() => WorkoutPlanNotifier();
}

String _$workoutPlanNotifierHash() =>
    r'beadcf05bc41f092e59b75adf93de87deab65486';

abstract class _$WorkoutPlanNotifier extends $AsyncNotifier<List<WorkoutPlan>> {
  FutureOr<List<WorkoutPlan>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<WorkoutPlan>>, List<WorkoutPlan>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<WorkoutPlan>>, List<WorkoutPlan>>,
              AsyncValue<List<WorkoutPlan>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(activePlan)
final activePlanProvider = ActivePlanProvider._();

final class ActivePlanProvider
    extends
        $FunctionalProvider<
          AsyncValue<WorkoutPlan?>,
          WorkoutPlan?,
          FutureOr<WorkoutPlan?>
        >
    with $FutureModifier<WorkoutPlan?>, $FutureProvider<WorkoutPlan?> {
  ActivePlanProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activePlanProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activePlanHash();

  @$internal
  @override
  $FutureProviderElement<WorkoutPlan?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WorkoutPlan?> create(Ref ref) {
    return activePlan(ref);
  }
}

String _$activePlanHash() => r'd3550526f65e8c91ec2839a41d14b51dfd996a4e';
