// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mealRepository)
final mealRepositoryProvider = MealRepositoryProvider._();

final class MealRepositoryProvider
    extends $FunctionalProvider<MealRepository, MealRepository, MealRepository>
    with $Provider<MealRepository> {
  MealRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealRepositoryHash();

  @$internal
  @override
  $ProviderElement<MealRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MealRepository create(Ref ref) {
    return mealRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MealRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MealRepository>(value),
    );
  }
}

String _$mealRepositoryHash() => r'6e967bacc594175991a847876716e4d67ca1bd67';

@ProviderFor(MealPlanNotifier)
final mealPlanProvider = MealPlanNotifierProvider._();

final class MealPlanNotifierProvider
    extends $AsyncNotifierProvider<MealPlanNotifier, List<MealPlan>> {
  MealPlanNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealPlanProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealPlanNotifierHash();

  @$internal
  @override
  MealPlanNotifier create() => MealPlanNotifier();
}

String _$mealPlanNotifierHash() => r'ddcd837c099d4b5e308cdb8d91f123e94d43aff8';

abstract class _$MealPlanNotifier extends $AsyncNotifier<List<MealPlan>> {
  FutureOr<List<MealPlan>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<MealPlan>>, List<MealPlan>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<MealPlan>>, List<MealPlan>>,
              AsyncValue<List<MealPlan>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(activeMealPlan)
final activeMealPlanProvider = ActiveMealPlanProvider._();

final class ActiveMealPlanProvider
    extends
        $FunctionalProvider<
          AsyncValue<MealPlan?>,
          MealPlan?,
          FutureOr<MealPlan?>
        >
    with $FutureModifier<MealPlan?>, $FutureProvider<MealPlan?> {
  ActiveMealPlanProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeMealPlanProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeMealPlanHash();

  @$internal
  @override
  $FutureProviderElement<MealPlan?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<MealPlan?> create(Ref ref) {
    return activeMealPlan(ref);
  }
}

String _$activeMealPlanHash() => r'6d24a74cca9f306a0f4b50c8431d1e902e7e467b';

@ProviderFor(RecipeNotifier)
final recipeProvider = RecipeNotifierProvider._();

final class RecipeNotifierProvider
    extends $AsyncNotifierProvider<RecipeNotifier, List<Recipe>> {
  RecipeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipeNotifierHash();

  @$internal
  @override
  RecipeNotifier create() => RecipeNotifier();
}

String _$recipeNotifierHash() => r'1a042da03f4b2a25dadf42d057d1f2ec8c6f5956';

abstract class _$RecipeNotifier extends $AsyncNotifier<List<Recipe>> {
  FutureOr<List<Recipe>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Recipe>>, List<Recipe>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Recipe>>, List<Recipe>>,
              AsyncValue<List<Recipe>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(recipesForPlan)
final recipesForPlanProvider = RecipesForPlanFamily._();

final class RecipesForPlanProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Recipe>>,
          List<Recipe>,
          FutureOr<List<Recipe>>
        >
    with $FutureModifier<List<Recipe>>, $FutureProvider<List<Recipe>> {
  RecipesForPlanProvider._({
    required RecipesForPlanFamily super.from,
    required MealPlan super.argument,
  }) : super(
         retry: null,
         name: r'recipesForPlanProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recipesForPlanHash();

  @override
  String toString() {
    return r'recipesForPlanProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Recipe>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Recipe>> create(Ref ref) {
    final argument = this.argument as MealPlan;
    return recipesForPlan(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RecipesForPlanProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recipesForPlanHash() => r'93ae4c0f96b79f321b7496e787d32113a3db22e4';

final class RecipesForPlanFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Recipe>>, MealPlan> {
  RecipesForPlanFamily._()
    : super(
        retry: null,
        name: r'recipesForPlanProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RecipesForPlanProvider call(MealPlan plan) =>
      RecipesForPlanProvider._(argument: plan, from: this);

  @override
  String toString() => r'recipesForPlanProvider';
}
