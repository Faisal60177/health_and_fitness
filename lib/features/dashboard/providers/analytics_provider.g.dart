// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AnalyticsNotifier)
final analyticsProvider = AnalyticsNotifierProvider._();

final class AnalyticsNotifierProvider
    extends $AsyncNotifierProvider<AnalyticsNotifier, AnalyticsData> {
  AnalyticsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsNotifierHash();

  @$internal
  @override
  AnalyticsNotifier create() => AnalyticsNotifier();
}

String _$analyticsNotifierHash() => r'120ba210320e7c0a5efeb82b303536e00e053ff4';

abstract class _$AnalyticsNotifier extends $AsyncNotifier<AnalyticsData> {
  FutureOr<AnalyticsData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AnalyticsData>, AnalyticsData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AnalyticsData>, AnalyticsData>,
              AsyncValue<AnalyticsData>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(activityHeatmap)
final activityHeatmapProvider = ActivityHeatmapProvider._();

final class ActivityHeatmapProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<DateTime, int>>,
          Map<DateTime, int>,
          FutureOr<Map<DateTime, int>>
        >
    with
        $FutureModifier<Map<DateTime, int>>,
        $FutureProvider<Map<DateTime, int>> {
  ActivityHeatmapProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityHeatmapProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityHeatmapHash();

  @$internal
  @override
  $FutureProviderElement<Map<DateTime, int>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<DateTime, int>> create(Ref ref) {
    return activityHeatmap(ref);
  }
}

String _$activityHeatmapHash() => r'8722610e2f7fcb79db7b52e7655a3104d1cadee8';
