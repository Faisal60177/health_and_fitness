// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calorie_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CalorieNotifier)
final calorieProvider = CalorieNotifierProvider._();

final class CalorieNotifierProvider
    extends $AsyncNotifierProvider<CalorieNotifier, NutritionState> {
  CalorieNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calorieProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calorieNotifierHash();

  @$internal
  @override
  CalorieNotifier create() => CalorieNotifier();
}

String _$calorieNotifierHash() => r'4a4fa13b2f09ca9b3cef2b0cb7e58988e75924a1';

abstract class _$CalorieNotifier extends $AsyncNotifier<NutritionState> {
  FutureOr<NutritionState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<NutritionState>, NutritionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<NutritionState>, NutritionState>,
              AsyncValue<NutritionState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
