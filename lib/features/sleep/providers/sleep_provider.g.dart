// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SleepNotifier)
final sleepProvider = SleepNotifierProvider._();

final class SleepNotifierProvider
    extends $AsyncNotifierProvider<SleepNotifier, List<SleepLog>> {
  SleepNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sleepProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sleepNotifierHash();

  @$internal
  @override
  SleepNotifier create() => SleepNotifier();
}

String _$sleepNotifierHash() => r'6b95433453d0ffebb8f84cb61a56bfed861baa44';

abstract class _$SleepNotifier extends $AsyncNotifier<List<SleepLog>> {
  FutureOr<List<SleepLog>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<SleepLog>>, List<SleepLog>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<SleepLog>>, List<SleepLog>>,
              AsyncValue<List<SleepLog>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
