// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workoutRepositoryHash() => r'36366b9d6c905dd0aa51006a52cb71b98a124b57';

/// See also [workoutRepository].
@ProviderFor(workoutRepository)
final workoutRepositoryProvider =
    AutoDisposeProvider<WorkoutRepository>.internal(
  workoutRepository,
  name: r'workoutRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$workoutRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WorkoutRepositoryRef = AutoDisposeProviderRef<WorkoutRepository>;
String _$workoutNotifierHash() => r'a259cb3ee82e776617fd92758f0c470b89ebd5f8';

/// See also [WorkoutNotifier].
@ProviderFor(WorkoutNotifier)
final workoutNotifierProvider = AutoDisposeAsyncNotifierProvider<
    WorkoutNotifier, List<WorkoutSession>>.internal(
  WorkoutNotifier.new,
  name: r'workoutNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$workoutNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WorkoutNotifier = AutoDisposeAsyncNotifier<List<WorkoutSession>>;
String _$activeWorkoutHash() => r'be270164eec857af9c44ac54b5af0146d2636de9';

/// See also [ActiveWorkout].
@ProviderFor(ActiveWorkout)
final activeWorkoutProvider =
    AutoDisposeNotifierProvider<ActiveWorkout, WorkoutSession?>.internal(
  ActiveWorkout.new,
  name: r'activeWorkoutProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeWorkoutHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ActiveWorkout = AutoDisposeNotifier<WorkoutSession?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
