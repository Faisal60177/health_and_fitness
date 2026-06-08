// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_counter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StepCounter)
final stepCounterProvider = StepCounterProvider._();

final class StepCounterProvider extends $NotifierProvider<StepCounter, int> {
  StepCounterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stepCounterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stepCounterHash();

  @$internal
  @override
  StepCounter create() => StepCounter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$stepCounterHash() => r'007fb6fe2bc2ae0662a253ce5999554b75079660';

abstract class _$StepCounter extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
