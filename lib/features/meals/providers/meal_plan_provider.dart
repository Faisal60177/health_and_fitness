import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/meal_plan.dart';
import '../../../data/repositories/meal_repository.dart';

part 'meal_plan_provider.g.dart';

// ── Repository provider ───────────────────────────────────
// Singleton so all meal providers share the same instance
@riverpod
MealRepository mealRepository(MealRepositoryRef ref) {
  return MealRepository();
}

// ── All meal plans ────────────────────────────────────────
// Loads templates + seeds built-in data on first launch
@riverpod
class MealPlanNotifier extends _$MealPlanNotifier {
  @override
  Future<List<MealPlan>> build() async {
    // Seed built-in recipes and plans if the DB is empty
    await ref.read(mealRepositoryProvider).seedIfEmpty();
    return ref.read(mealRepositoryProvider).getAllMealPlans();
  }

  Future<void> activatePlan(int planId) async {
    await ref.read(mealRepositoryProvider).activatePlan(planId);
    // Invalidate so the UI rebuilds with the updated active flag
    ref.invalidateSelf();
    await future;
  }

  Future<void> deactivatePlan(int planId) async {
    await ref.read(mealRepositoryProvider).deactivatePlan(planId);
    ref.invalidateSelf();
    await future;
  }
}

// ── Active meal plan ──────────────────────────────────────
// Separate provider so only the active-plan banner rebuilds
// when the active plan changes — not the whole plans list
@riverpod
Future<MealPlan?> activeMealPlan(ActiveMealPlanRef ref) async {
  // Watch the notifier so this re-runs when plans change
  ref.watch(mealPlanNotifierProvider);
  return ref.read(mealRepositoryProvider).getActivePlan();
}

// ── All recipes ───────────────────────────────────────────
@riverpod
class RecipeNotifier extends _$RecipeNotifier {
  @override
  Future<List<Recipe>> build() async {
    await ref.read(mealRepositoryProvider).seedIfEmpty();
    return ref.read(mealRepositoryProvider).getAllRecipes();
  }

  Future<void> filterByCategory(String? category) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (category == null) {
        return ref.read(mealRepositoryProvider).getAllRecipes();
      }
      return ref.read(mealRepositoryProvider)
          .getRecipesByCategory(category);
    });
  }

  Future<void> filterByTag(String tag) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
          () => ref.read(mealRepositoryProvider).getRecipesByTag(tag),
    );
  }

  Future<void> search(String query) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (query.isEmpty) {
        return ref.read(mealRepositoryProvider).getAllRecipes();
      }
      return ref.read(mealRepositoryProvider).searchRecipes(query);
    });
  }

  void reset() {
    ref.invalidateSelf();
  }
}

// ── Recipes for a specific meal plan ─────────────────────
// Used by the plan detail screen to show the recipe list
@riverpod
Future<List<Recipe>> recipesForPlan(
    RecipesForPlanRef ref,
    MealPlan plan,
    ) async {
  return ref.read(mealRepositoryProvider).getRecipesForPlan(plan);
}