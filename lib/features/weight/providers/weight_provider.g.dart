// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$latestWeightHash() => r'8659605bcda526e65ff035f3bc9d384e23d93a3b';

/// See also [latestWeight].
@ProviderFor(latestWeight)
final latestWeightProvider = AutoDisposeFutureProvider<WeightLog?>.internal(
  latestWeight,
  name: r'latestWeightProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$latestWeightHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LatestWeightRef = AutoDisposeFutureProviderRef<WeightLog?>;
String _$weightNotifierHash() => r'979c7c35f5e9aae4503184913bb16fe5bcd6183e';

/// See also [WeightNotifier].
@ProviderFor(WeightNotifier)
final weightNotifierProvider =
    AutoDisposeAsyncNotifierProvider<WeightNotifier, List<WeightLog>>.internal(
  WeightNotifier.new,
  name: r'weightNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$weightNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WeightNotifier = AutoDisposeAsyncNotifier<List<WeightLog>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
