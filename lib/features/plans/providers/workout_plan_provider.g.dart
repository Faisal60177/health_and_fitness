// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_plan_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activePlanHash() => r'f0e0f11d6b1437559f7d04de7a9a37e5361a39bc';

/// See also [activePlan].
@ProviderFor(activePlan)
final activePlanProvider = AutoDisposeFutureProvider<WorkoutPlan?>.internal(
  activePlan,
  name: r'activePlanProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$activePlanHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ActivePlanRef = AutoDisposeFutureProviderRef<WorkoutPlan?>;
String _$workoutPlanNotifierHash() =>
    r'47e7dc3ee6d673d56a91792a2282d89681485be5';

/// See also [WorkoutPlanNotifier].
@ProviderFor(WorkoutPlanNotifier)
final workoutPlanNotifierProvider = AutoDisposeAsyncNotifierProvider<
    WorkoutPlanNotifier, List<WorkoutPlan>>.internal(
  WorkoutPlanNotifier.new,
  name: r'workoutPlanNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$workoutPlanNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WorkoutPlanNotifier = AutoDisposeAsyncNotifier<List<WorkoutPlan>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
