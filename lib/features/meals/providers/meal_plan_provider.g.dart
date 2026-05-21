// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mealRepositoryHash() => r'607e889699211d3aa17bae522b1760e3090fa208';

/// See also [mealRepository].
@ProviderFor(mealRepository)
final mealRepositoryProvider = AutoDisposeProvider<MealRepository>.internal(
  mealRepository,
  name: r'mealRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mealRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MealRepositoryRef = AutoDisposeProviderRef<MealRepository>;
String _$activeMealPlanHash() => r'ae1d5c0a3a651640e5c0265d1d81ab6fd658002a';

/// See also [activeMealPlan].
@ProviderFor(activeMealPlan)
final activeMealPlanProvider = AutoDisposeFutureProvider<MealPlan?>.internal(
  activeMealPlan,
  name: r'activeMealPlanProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeMealPlanHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ActiveMealPlanRef = AutoDisposeFutureProviderRef<MealPlan?>;
String _$recipesForPlanHash() => r'db252529aacdd0ed039e21dd7b50f71899494e54';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [recipesForPlan].
@ProviderFor(recipesForPlan)
const recipesForPlanProvider = RecipesForPlanFamily();

/// See also [recipesForPlan].
class RecipesForPlanFamily extends Family<AsyncValue<List<Recipe>>> {
  /// See also [recipesForPlan].
  const RecipesForPlanFamily();

  /// See also [recipesForPlan].
  RecipesForPlanProvider call(
    MealPlan plan,
  ) {
    return RecipesForPlanProvider(
      plan,
    );
  }

  @override
  RecipesForPlanProvider getProviderOverride(
    covariant RecipesForPlanProvider provider,
  ) {
    return call(
      provider.plan,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recipesForPlanProvider';
}

/// See also [recipesForPlan].
class RecipesForPlanProvider extends AutoDisposeFutureProvider<List<Recipe>> {
  /// See also [recipesForPlan].
  RecipesForPlanProvider(
    MealPlan plan,
  ) : this._internal(
          (ref) => recipesForPlan(
            ref as RecipesForPlanRef,
            plan,
          ),
          from: recipesForPlanProvider,
          name: r'recipesForPlanProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$recipesForPlanHash,
          dependencies: RecipesForPlanFamily._dependencies,
          allTransitiveDependencies:
              RecipesForPlanFamily._allTransitiveDependencies,
          plan: plan,
        );

  RecipesForPlanProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.plan,
  }) : super.internal();

  final MealPlan plan;

  @override
  Override overrideWith(
    FutureOr<List<Recipe>> Function(RecipesForPlanRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecipesForPlanProvider._internal(
        (ref) => create(ref as RecipesForPlanRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        plan: plan,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Recipe>> createElement() {
    return _RecipesForPlanProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecipesForPlanProvider && other.plan == plan;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, plan.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RecipesForPlanRef on AutoDisposeFutureProviderRef<List<Recipe>> {
  /// The parameter `plan` of this provider.
  MealPlan get plan;
}

class _RecipesForPlanProviderElement
    extends AutoDisposeFutureProviderElement<List<Recipe>>
    with RecipesForPlanRef {
  _RecipesForPlanProviderElement(super.provider);

  @override
  MealPlan get plan => (origin as RecipesForPlanProvider).plan;
}

String _$mealPlanNotifierHash() => r'ddcd837c099d4b5e308cdb8d91f123e94d43aff8';

/// See also [MealPlanNotifier].
@ProviderFor(MealPlanNotifier)
final mealPlanNotifierProvider =
    AutoDisposeAsyncNotifierProvider<MealPlanNotifier, List<MealPlan>>.internal(
  MealPlanNotifier.new,
  name: r'mealPlanNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mealPlanNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MealPlanNotifier = AutoDisposeAsyncNotifier<List<MealPlan>>;
String _$recipeNotifierHash() => r'1a042da03f4b2a25dadf42d057d1f2ec8c6f5956';

/// See also [RecipeNotifier].
@ProviderFor(RecipeNotifier)
final recipeNotifierProvider =
    AutoDisposeAsyncNotifierProvider<RecipeNotifier, List<Recipe>>.internal(
  RecipeNotifier.new,
  name: r'recipeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recipeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RecipeNotifier = AutoDisposeAsyncNotifier<List<Recipe>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
