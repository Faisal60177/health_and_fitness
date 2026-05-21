// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activityHeatmapHash() => r'4de80e6274df72a8739097115e6f6a8e14eea23c';

/// See also [activityHeatmap].
@ProviderFor(activityHeatmap)
final activityHeatmapProvider =
    AutoDisposeFutureProvider<Map<DateTime, int>>.internal(
  activityHeatmap,
  name: r'activityHeatmapProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activityHeatmapHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ActivityHeatmapRef = AutoDisposeFutureProviderRef<Map<DateTime, int>>;
String _$analyticsNotifierHash() => r'3f8c1124c13abe67f84eae713a060ddf9ee64625';

/// See also [AnalyticsNotifier].
@ProviderFor(AnalyticsNotifier)
final analyticsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<AnalyticsNotifier, AnalyticsData>.internal(
  AnalyticsNotifier.new,
  name: r'analyticsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$analyticsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AnalyticsNotifier = AutoDisposeAsyncNotifier<AnalyticsData>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
