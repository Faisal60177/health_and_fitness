// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExerciseNotifier)
final exerciseProvider = ExerciseNotifierProvider._();

final class ExerciseNotifierProvider
    extends $NotifierProvider<ExerciseNotifier, ExerciseState> {
  ExerciseNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exerciseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exerciseNotifierHash();

  @$internal
  @override
  ExerciseNotifier create() => ExerciseNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExerciseState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExerciseState>(value),
    );
  }
}

String _$exerciseNotifierHash() => r'79761f4de2412650ac286f21298f9df0d5beeb60';

abstract class _$ExerciseNotifier extends $Notifier<ExerciseState> {
  ExerciseState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ExerciseState, ExerciseState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ExerciseState, ExerciseState>,
              ExerciseState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
