import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/meal_plan.dart';
import '../../../data/models/meal_plan.dart' show Recipe;
import '../providers/meal_plan_provider.dart';
import 'recipe_detail_screen.dart';

class MealPlansScreen extends ConsumerStatefulWidget {
  const MealPlansScreen({super.key});

  @override
  ConsumerState<MealPlansScreen> createState() => _MealPlansScreenState();
}

class _MealPlansScreenState extends ConsumerState<MealPlansScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  // Category filter — null means "All"
  String? _selectedCategory;

  // Tag filter chips data
  static const _tags = [
    'All',
    'high-protein',
    'vegan',
    'quick',
    'low-calorie',
    'low-carb',
    'meal-prep',
    'no-cook',
  ];
  String _selectedTag = 'All';

  @override
  void initState() {
    super.initState();
    // Two tabs: Meal Plans library | Recipe browser
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Meal Plans & Recipes',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textHint,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: 'Meal Plans'),
            Tab(text: 'Recipes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PlansTab(),
          _RecipesTab(
            searchController: _searchController,
            selectedTag: _selectedTag,
            tags: _tags,
            onTagSelected: (tag) {
              setState(() => _selectedTag = tag);
              if (tag == 'All') {
                ref.read(recipeProvider.notifier).reset();
              } else {
                ref
                    .read(recipeProvider.notifier)
                    .filterByTag(tag);
              }
            },
            onSearch: (q) {
              ref.read(recipeProvider.notifier).search(q);
            },
            onClearSearch: () {
              _searchController.clear();
              ref.read(recipeProvider.notifier).reset();
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Tab 1: Meal Plans Library
// ─────────────────────────────────────────────────────────
class _PlansTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync      = ref.watch(mealPlanProvider);
    final activePlanAsync = ref.watch(activeMealPlanProvider);

    return plansAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (plans) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Active plan banner
          activePlanAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (active) => active != null
                ? _ActivePlanBanner(plan: active, ref: ref)
                : const SizedBox.shrink(),
          ),

          const SizedBox(height: 8),

          Text(
            'Choose a plan',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'Structured eating plans matched to your fitness goal.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),

          ...plans.map(
                (plan) => _MealPlanCard(
              plan: plan,
              ref: ref,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Tab 2: Recipe Browser
// ─────────────────────────────────────────────────────────
class _RecipesTab extends ConsumerWidget {
  final TextEditingController searchController;
  final String selectedTag;
  final List<String> tags;
  final ValueChanged<String> onTagSelected;
  final ValueChanged<String> onSearch;
  final VoidCallback onClearSearch;

  const _RecipesTab({
    required this.searchController,
    required this.selectedTag,
    required this.tags,
    required this.onTagSelected,
    required this.onSearch,
    required this.onClearSearch,
  });

  // Category meal-type icons
  static const _categoryIcons = {
    'breakfast': Icons.free_breakfast_rounded,
    'lunch':     Icons.lunch_dining_rounded,
    'dinner':    Icons.dinner_dining_rounded,
    'snack':     Icons.cookie_rounded,
  };

  static const _categoryColors = {
    'breakfast': Color(0xFFFFD54F),
    'lunch':     Color(0xFF42A5F5),
    'dinner':    Color(0xFFA78BFA),
    'snack':     Color(0xFFFF7043),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesAsync = ref.watch(recipeProvider);

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: searchController,
            style: const TextStyle(color: AppColors.textPrimary),
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: 'Search recipes...',
              hintStyle: const TextStyle(color: AppColors.textHint),
              prefixIcon: const Icon(Icons.search_rounded,
                  color: AppColors.textHint),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear_rounded,
                    color: AppColors.textHint, size: 18),
                onPressed: onClearSearch,
              )
                  : null,
              filled: true,
              fillColor: AppColors.surfaceMuted,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),

        // Tag filter chips
        SizedBox(
          height: 42,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: tags.length,
            itemBuilder: (ctx, i) {
              final tag = tags[i];
              final isSelected = tag == selectedTag;
              return GestureDetector(
                onTap: () => onTagSelected(tag),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tag == 'All' ? 'All' : tag,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? Colors.black
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        // Recipe list
        Expanded(
          child: recipesAsync.when(
            loading: () =>
            const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Center(child: Text('Error: $e')),
            data: (recipes) => recipes.isEmpty
                ? _EmptyRecipes()
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: recipes.length,
              itemBuilder: (ctx, i) {
                final recipe = recipes[i];
                return _RecipeCard(
                  recipe: recipe,
                  categoryIcon: _categoryIcons[recipe.category] ??
                      Icons.restaurant_rounded,
                  categoryColor:
                  _categoryColors[recipe.category] ??
                      AppColors.primary,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          RecipeDetailScreen(recipe: recipe),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Widgets
// ─────────────────────────────────────────────────────────

class _ActivePlanBanner extends StatelessWidget {
  final MealPlan plan;
  final WidgetRef ref;
  const _ActivePlanBanner({required this.plan, required this.ref});

  @override
  Widget build(BuildContext context) {
    final goalColor = _goalColor(plan.goal);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: goalColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: goalColor.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_rounded, color: goalColor, size: 16),
              const SizedBox(width: 8),
              Text(
                'Active Plan',
                style: TextStyle(
                    color: goalColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
              ),
              const Spacer(),
              // Deactivate button
              GestureDetector(
                onTap: () => ref
                    .read(mealPlanProvider.notifier)
                    .deactivatePlan(plan.id),
                child: const Text(
                  'Stop plan',
                  style: TextStyle(
                      color: AppColors.textHint, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            plan.name,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _PlanChip(
                  '${plan.dailyCalorieTarget} kcal/day',
                  color: goalColor),
              const SizedBox(width: 8),
              _PlanChip('${plan.durationDays} days', color: goalColor),
            ],
          ),
        ],
      ),
    );
  }
}

class _MealPlanCard extends StatelessWidget {
  final MealPlan plan;
  final WidgetRef ref;
  const _MealPlanCard({required this.plan, required this.ref});

  @override
  Widget build(BuildContext context) {
    final goalColor = _goalColor(plan.goal);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: plan.isActive
              ? goalColor.withOpacity(0.5)
              : AppColors.surfaceMuted,
          width: plan.isActive ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: goalColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _goalIcon(plan.goal),
                    color: goalColor, size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 3),
                      _PlanChip(
                        plan.goal.replaceAll('_', ' '),
                        color: goalColor,
                      ),
                    ],
                  ),
                ),
                if (plan.isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: goalColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Active',
                      style: TextStyle(
                          fontSize: 11,
                          color: goalColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              plan.description,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 14),

            // Stats row
            Row(
              children: [
                _StatChip(
                    Icons.local_fire_department_rounded,
                    '${plan.dailyCalorieTarget} kcal/day'),
                const SizedBox(width: 8),
                _StatChip(
                    Icons.calendar_today_rounded,
                    '${plan.durationDays} days'),
                const SizedBox(width: 8),
                _StatChip(
                    Icons.restaurant_rounded,
                    '${plan.recipeIds.length} recipes'),
              ],
            ),

            const SizedBox(height: 14),

            // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: plan.isActive
                    ? () => ref
                    .read(mealPlanProvider.notifier)
                    .deactivatePlan(plan.id)
                    : () => ref
                    .read(mealPlanProvider.notifier)
                    .activatePlan(plan.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: plan.isActive
                      ? AppColors.surfaceMuted
                      : goalColor,
                  foregroundColor: plan.isActive
                      ? AppColors.textSecondary
                      : Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  plan.isActive ? 'Stop this plan' : 'Start this plan',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final IconData categoryIcon;
  final Color categoryColor;
  final VoidCallback onTap;

  const _RecipeCard({
    required this.recipe,
    required this.categoryIcon,
    required this.categoryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.surfaceMuted),
        ),
        child: Row(
          children: [
            // Category icon
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(categoryIcon, color: categoryColor, size: 24),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recipe.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Macros row
                  Row(
                    children: [
                      _MacroBadge(
                          '${recipe.caloriesPerServing.toStringAsFixed(0)} kcal',
                          color: const Color(0xFFFF7043)),
                      const SizedBox(width: 6),
                      _MacroBadge(
                          'P: ${recipe.proteinG.toStringAsFixed(0)}g',
                          color: const Color(0xFF42A5F5)),
                      const SizedBox(width: 6),
                      _MacroBadge(
                          '${recipe.totalTime}',
                          color: AppColors.textHint),
                    ],
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}

// ── Small reusable widgets ────────────────────────────────

class _PlanChip extends StatelessWidget {
  final String label;
  final Color color;
  const _PlanChip(this.label, {required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 11, color: color, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _StatChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.textHint),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: AppColors.textHint)),
      ],
    );
  }
}

class _MacroBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _MacroBadge(this.label, {required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, color: color),
      ),
    );
  }
}

class _EmptyRecipes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.no_meals_rounded,
              size: 52, color: AppColors.textHint),
          const SizedBox(height: 12),
          Text('No recipes found',
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

// ── Goal helpers ──────────────────────────────────────────

Color _goalColor(String goal) {
  switch (goal) {
    case 'muscle_gain':  return const Color(0xFFA78BFA);
    case 'weight_loss':  return AppColors.success;
    case 'maintenance':  return const Color(0xFF42A5F5);
    default:             return AppColors.primary;
  }
}

IconData _goalIcon(String goal) {
  switch (goal) {
    case 'muscle_gain':  return Icons.fitness_center_rounded;
    case 'weight_loss':  return Icons.trending_down_rounded;
    case 'maintenance':  return Icons.balance_rounded;
    default:             return Icons.restaurant_rounded;
  }
}




