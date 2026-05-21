import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/meal_plan.dart';
import '../../../data/repositories/food_repository.dart';
import '../../../data/models/food_log.dart';

class RecipeDetailScreen extends ConsumerStatefulWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  ConsumerState<RecipeDetailScreen> createState() =>
      _RecipeDetailScreenState();
}

class _RecipeDetailScreenState
    extends ConsumerState<RecipeDetailScreen> {
  bool _logged = false;

  // One-tap log this recipe to today's food diary
  // Connects Phase 5 (recipes) → Phase 3 (calorie tracker)
  Future<void> _logToCalorieTracker() async {
    final entry = FoodLog()
      ..date              = DateTime.now()
      ..foodName          = widget.recipe.name
      ..calories          = widget.recipe.caloriesPerServing
      ..proteinG          = widget.recipe.proteinG
      ..carbsG            = widget.recipe.carbsG
      ..fatG              = widget.recipe.fatG
      ..servingSize       = 100
      ..mealType          = _guessedMealType();

    await FoodRepository().logFood(entry);
    setState(() => _logged = true);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.recipe.name} logged to your food diary'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Guess meal type based on recipe category
  MealType _guessedMealType() {
    switch (widget.recipe.category) {
      case 'breakfast': return MealType.breakfast;
      case 'lunch':     return MealType.lunch;
      case 'dinner':    return MealType.dinner;
      default:          return MealType.snack;
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Collapsible header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.surfaceCard,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.surfaceCard,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Icon(
                      _categoryIcon(recipe.category),
                      size: 72,
                      color: _categoryColor(recipe.category)
                          .withOpacity(0.7),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // ── Title + tags ──────────────────────────
                Text(
                  recipe.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: recipe.tags
                      .map((t) => _TagChip(label: t))
                      .toList(),
                ),
                const SizedBox(height: 16),

                // ── Time + servings stats ─────────────────
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.surfaceMuted),
                  ),
                  child: Row(
                    children: [
                      _StatCell(
                          icon: Icons.timer_rounded,
                          label: 'Prep',
                          value: '${recipe.prepMinutes}m'),
                      _Divider(),
                      _StatCell(
                          icon: Icons.whatshot_rounded,
                          label: 'Cook',
                          value: '${recipe.cookMinutes}m'),
                      _Divider(),
                      _StatCell(
                          icon: Icons.schedule_rounded,
                          label: 'Total',
                          value: recipe.totalTime),
                      _Divider(),
                      _StatCell(
                          icon: Icons.people_rounded,
                          label: 'Serves',
                          value: '${recipe.servings}'),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Macro nutrition card ──────────────────
                _MacroCard(recipe: recipe),

                const SizedBox(height: 24),

                // ── Description ───────────────────────────
                if (recipe.description.isNotEmpty) ...[
                  _SectionTitle('About this recipe'),
                  const SizedBox(height: 8),
                  Text(
                    recipe.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(height: 1.6),
                  ),
                  const SizedBox(height: 24),
                ],

                // ── Ingredients ───────────────────────────
                _SectionTitle('Ingredients'),
                const SizedBox(height: 4),
                Text(
                  'Per serving (×${recipe.servings})',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 12),
                ...recipe.ingredients.asMap().entries.map(
                      (e) => _IngredientRow(
                    ingredient: e.value,
                    isLast: e.key == recipe.ingredients.length - 1,
                  ),
                ),

                const SizedBox(height: 24),

                // ── Instructions ──────────────────────────
                _SectionTitle('Instructions'),
                const SizedBox(height: 12),
                ...recipe.instructions.asMap().entries.map(
                      (e) => _InstructionStep(
                    step: e.key + 1,
                    text: e.value,
                  ),
                ),

                const SizedBox(height: 32),

                // ── Log to food diary button ──────────────
                // This is the Phase 3 → Phase 5 connection point:
                // Recipe data flows into the calorie tracker
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _logged ? null : _logToCalorieTracker,
                    icon: Icon(
                      _logged
                          ? Icons.check_circle_rounded
                          : Icons.add_circle_rounded,
                    ),
                    label: Text(
                      _logged
                          ? 'Logged to food diary'
                          : 'Log to today\'s food diary',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      _logged ? AppColors.success : AppColors.primary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Nutrition note ────────────────────────
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          color: AppColors.textHint, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Nutritional values are per serving and may vary '
                              'based on exact ingredients used.',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Section widgets
// ─────────────────────────────────────────────────────────

class _MacroCard extends StatelessWidget {
  final Recipe recipe;
  const _MacroCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutrition per serving',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Calorie circle
              _CalorieCircle(calories: recipe.caloriesPerServing),
              const SizedBox(width: 20),
              // Macro bars
              Expanded(
                child: Column(
                  children: [
                    _MacroBar(
                      label: 'Protein',
                      value: recipe.proteinG,
                      unit: 'g',
                      color: const Color(0xFF42A5F5),
                      maxValue: 60,
                    ),
                    const SizedBox(height: 8),
                    _MacroBar(
                      label: 'Carbs',
                      value: recipe.carbsG,
                      unit: 'g',
                      color: const Color(0xFFFFD54F),
                      maxValue: 100,
                    ),
                    const SizedBox(height: 8),
                    _MacroBar(
                      label: 'Fat',
                      value: recipe.fatG,
                      unit: 'g',
                      color: const Color(0xFFEF9A9A),
                      maxValue: 40,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CalorieCircle extends StatelessWidget {
  final double calories;
  const _CalorieCircle({required this.calories});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80, height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFF7043).withOpacity(0.1),
        border: Border.all(
            color: const Color(0xFFFF7043).withOpacity(0.4), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            calories.toStringAsFixed(0),
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF7043)),
          ),
          const Text(
            'kcal',
            style: TextStyle(fontSize: 10, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  final String label;
  final double value;
  final String unit;
  final Color color;
  final double maxValue; // for proportional bar width

  const _MacroBar({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (value / maxValue).clamp(0.0, 1.0);

    return Column(
      children: [
        Row(
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
            const Spacer(),
            Text('${value.toStringAsFixed(1)}$unit',
                style: TextStyle(
                    fontSize: 12, color: color,
                    fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: color.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _IngredientRow extends StatelessWidget {
  final RecipeIngredient ingredient;
  final bool isLast;
  const _IngredientRow({required this.ingredient, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
            bottom: BorderSide(
                color: AppColors.surfaceMuted, width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 6, height: 6,
            margin: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
          ),
          Expanded(
            child: Text(
              ingredient.name,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            '${ingredient.amount % 1 == 0 ? ingredient.amount.toInt() : ingredient.amount} ${ingredient.unit}',
            style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
                fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _InstructionStep extends StatelessWidget {
  final int step;
  final String text;
  const _InstructionStep({required this.step, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30, height: 30,
            margin: const EdgeInsets.only(right: 12, top: 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$step',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary),
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(height: 1.55),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Small reusable widgets
// ─────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
            fontSize: 11, color: AppColors.textSecondary),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatCell(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 14)),
          Text(label,
              style: const TextStyle(
                  fontSize: 10, color: AppColors.textHint)),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1, height: 40, color: AppColors.surfaceMuted);
  }
}

// ─────────────────────────────────────────────────────────
// Category icon / color helpers
// ─────────────────────────────────────────────────────────

IconData _categoryIcon(String category) {
  switch (category) {
    case 'breakfast': return Icons.free_breakfast_rounded;
    case 'lunch':     return Icons.lunch_dining_rounded;
    case 'dinner':    return Icons.dinner_dining_rounded;
    default:          return Icons.cookie_rounded;
  }
}

Color _categoryColor(String category) {
  switch (category) {
    case 'breakfast': return const Color(0xFFFFD54F);
    case 'lunch':     return const Color(0xFF42A5F5);
    case 'dinner':    return const Color(0xFFA78BFA);
    default:          return const Color(0xFFFF7043);
  }
}