// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StepNotifier)
final stepProvider = StepNotifierProvider._();

final class StepNotifierProvider
    extends $NotifierProvider<StepNotifier, StepState> {
  StepNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stepProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stepNotifierHash();

  @$internal
  @override
  StepNotifier create() => StepNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StepState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StepState>(value),
    );
  }
}

String _$stepNotifierHash() => r'f37e182dc5c7db6faccbf577238fb1ae7556dffd';

abstract class _$StepNotifier extends $Notifier<StepState> {
  StepState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<StepState, StepState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StepState, StepState>,
              StepState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
