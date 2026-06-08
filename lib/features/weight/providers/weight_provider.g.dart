// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WeightNotifier)
final weightProvider = WeightNotifierProvider._();

final class WeightNotifierProvider
    extends $AsyncNotifierProvider<WeightNotifier, List<WeightLog>> {
  WeightNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weightProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weightNotifierHash();

  @$internal
  @override
  WeightNotifier create() => WeightNotifier();
}

String _$weightNotifierHash() => r'979c7c35f5e9aae4503184913bb16fe5bcd6183e';

abstract class _$WeightNotifier extends $AsyncNotifier<List<WeightLog>> {
  FutureOr<List<WeightLog>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<WeightLog>>, List<WeightLog>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<WeightLog>>, List<WeightLog>>,
              AsyncValue<List<WeightLog>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(latestWeight)
final latestWeightProvider = LatestWeightProvider._();

final class LatestWeightProvider
    extends
        $FunctionalProvider<
          AsyncValue<WeightLog?>,
          WeightLog?,
          FutureOr<WeightLog?>
        >
    with $FutureModifier<WeightLog?>, $FutureProvider<WeightLog?> {
  LatestWeightProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'latestWeightProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$latestWeightHash();

  @$internal
  @override
  $FutureProviderElement<WeightLog?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<WeightLog?> create(Ref ref) {
    return latestWeight(ref);
  }
}

String _$latestWeightHash() => r'2e32e514845af3109e33c3ae09c810e590aff3cc';
