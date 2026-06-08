// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'premium_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PremiumNotifier)
final premiumProvider = PremiumNotifierProvider._();

final class PremiumNotifierProvider
    extends $AsyncNotifierProvider<PremiumNotifier, List<ProductDetails>> {
  PremiumNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'premiumProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$premiumNotifierHash();

  @$internal
  @override
  PremiumNotifier create() => PremiumNotifier();
}

String _$premiumNotifierHash() => r'40c86d2ca4b5ede99fd4b3ebefdb7426ca7d1588';

abstract class _$PremiumNotifier extends $AsyncNotifier<List<ProductDetails>> {
  FutureOr<List<ProductDetails>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<ProductDetails>>, List<ProductDetails>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ProductDetails>>,
                List<ProductDetails>
              >,
              AsyncValue<List<ProductDetails>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
