// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(workoutRepository)
final workoutRepositoryProvider = WorkoutRepositoryProvider._();

final class WorkoutRepositoryProvider
    extends
        $FunctionalProvider<
          WorkoutRepository,
          WorkoutRepository,
          WorkoutRepository
        >
    with $Provider<WorkoutRepository> {
  WorkoutRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutRepositoryHash();

  @$internal
  @override
  $ProviderElement<WorkoutRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WorkoutRepository create(Ref ref) {
    return workoutRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutRepository>(value),
    );
  }
}

String _$workoutRepositoryHash() => r'0b49071499c2b46c05612c9c970cd5f463fe7280';

@ProviderFor(WorkoutNotifier)
final workoutProvider = WorkoutNotifierProvider._();

final class WorkoutNotifierProvider
    extends $AsyncNotifierProvider<WorkoutNotifier, List<WorkoutSession>> {
  WorkoutNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutNotifierHash();

  @$internal
  @override
  WorkoutNotifier create() => WorkoutNotifier();
}

String _$workoutNotifierHash() => r'a259cb3ee82e776617fd92758f0c470b89ebd5f8';

abstract class _$WorkoutNotifier extends $AsyncNotifier<List<WorkoutSession>> {
  FutureOr<List<WorkoutSession>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<WorkoutSession>>, List<WorkoutSession>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<WorkoutSession>>,
                List<WorkoutSession>
              >,
              AsyncValue<List<WorkoutSession>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ActiveWorkout)
final activeWorkoutProvider = ActiveWorkoutProvider._();

final class ActiveWorkoutProvider
    extends $NotifierProvider<ActiveWorkout, WorkoutSession?> {
  ActiveWorkoutProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeWorkoutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeWorkoutHash();

  @$internal
  @override
  ActiveWorkout create() => ActiveWorkout();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutSession? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutSession?>(value),
    );
  }
}

String _$activeWorkoutHash() => r'794d3873bd7d07c28f75ebe2561c27fcf8b54a2e';

abstract class _$ActiveWorkout extends $Notifier<WorkoutSession?> {
  WorkoutSession? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<WorkoutSession?, WorkoutSession?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WorkoutSession?, WorkoutSession?>,
              WorkoutSession?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
