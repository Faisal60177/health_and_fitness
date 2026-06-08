// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WaterNotifier)
final waterProvider = WaterNotifierProvider._();

final class WaterNotifierProvider
    extends $AsyncNotifierProvider<WaterNotifier, WaterState> {
  WaterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'waterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$waterNotifierHash();

  @$internal
  @override
  WaterNotifier create() => WaterNotifier();
}

String _$waterNotifierHash() => r'cf9b92d1af452f98a79e7d2853dc0ee498867abc';

abstract class _$WaterNotifier extends $AsyncNotifier<WaterState> {
  FutureOr<WaterState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<WaterState>, WaterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<WaterState>, WaterState>,
              AsyncValue<WaterState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
