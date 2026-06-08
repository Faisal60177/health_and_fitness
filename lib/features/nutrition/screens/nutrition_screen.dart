import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/food_log.dart';
import '../providers/calorie_provider.dart';
import 'package:health_and_fitness/core/router/app_router.dart';
import 'package:go_router/go_router.dart';

class NutritionScreen extends ConsumerWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nutritionAsync = ref.watch(calorieProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: nutritionAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (state) => CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Text('Nutrition',
                        style: Theme.of(context).textTheme.headlineLarge),
                    Text('Today\'s food log',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 24),

                    // Add at the top of the Nutrition screen body, before the calorie card:
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.meals),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA78BFA).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: const Color(0xFFA78BFA).withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.menu_book_rounded,
                                color: Color(0xFFA78BFA), size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Meal Plans & Recipes',
                                    style: TextStyle(
                                        color: Color(0xFFA78BFA),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'Browse plans and log recipes directly to your diary',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded,
                                color: AppColors.textHint),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Calorie summary card
                    _CalorieSummaryCard(state: state),
                    const SizedBox(height: 16),

                    // Macro breakdown
                    _MacroRow(state: state),
                    const SizedBox(height: 24),

                    // Add food button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _showAddFoodDialog(context, ref),
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Log food'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.black,
                          padding:
                          const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Meal sections
                    ...MealType.values.map((meal) {
                      final mealLogs =
                          state.byMeal[meal] ?? [];
                      if (mealLogs.isEmpty) return const SizedBox.shrink();
                      return _MealSection(
                        meal: meal,
                        logs: mealLogs,
                        ref: ref,
                      );
                    }),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddFoodDialog(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final calCtrl = TextEditingController();
    final proteinCtrl = TextEditingController();
    final carbCtrl = TextEditingController();
    final fatCtrl = TextEditingController();
    MealType selectedMeal = MealType.lunch;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.fromLTRB(
              24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Log food',
                  style: Theme.of(ctx).textTheme.headlineMedium),
              const SizedBox(height: 16),

              // Meal type selector
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: MealType.values.map((m) {
                    final isSelected = m == selectedMeal;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => selectedMeal = m),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.surfaceMuted,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            m.name[0].toUpperCase() + m.name.substring(1),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.black
                                  : AppColors.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),

              _InputField(ctrl: nameCtrl, hint: 'Food name', label: 'Name'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _InputField(
                      ctrl: calCtrl, hint: '0', label: 'Calories', isNumber: true)),
                  const SizedBox(width: 10),
                  Expanded(child: _InputField(
                      ctrl: proteinCtrl, hint: '0g', label: 'Protein', isNumber: true)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _InputField(
                      ctrl: carbCtrl, hint: '0g', label: 'Carbs', isNumber: true)),
                  const SizedBox(width: 10),
                  Expanded(child: _InputField(
                      ctrl: fatCtrl, hint: '0g', label: 'Fat', isNumber: true)),
                ],
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final entry = FoodLog()
                      ..date = DateTime.now()
                      ..foodName = nameCtrl.text.trim()
                      ..calories = double.tryParse(calCtrl.text) ?? 0
                      ..proteinG = double.tryParse(proteinCtrl.text) ?? 0
                      ..carbsG = double.tryParse(carbCtrl.text) ?? 0
                      ..fatG = double.tryParse(fatCtrl.text) ?? 0
                      ..servingSize = 100
                      ..mealType = selectedMeal;

                    ref
                        .read(calorieProvider.notifier)
                        .logFood(entry);
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class _CalorieSummaryCard extends StatelessWidget {
  final NutritionState state;
  const _CalorieSummaryCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Calories eaten',
                        style: Theme.of(context).textTheme.bodyMedium),
                    Text(
                      '${state.totalCalories.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Remaining',
                        style: Theme.of(context).textTheme.bodyMedium),
                    Text(
                      '${state.remainingCalories.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: state.calorieProgress,
                minHeight: 8,
                backgroundColor: AppColors.surfaceMuted,
                valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Goal: ${state.calorieGoal.toStringAsFixed(0)} kcal',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroRow extends StatelessWidget {
  final NutritionState state;
  const _MacroRow({required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MacroCard(
          label: 'Protein',
          value: state.totalProtein,
          unit: 'g',
          color: const Color(0xFF4FC3F7),
        ),
        const SizedBox(width: 8),
        _MacroCard(
          label: 'Carbs',
          value: state.totalCarbs,
          unit: 'g',
          color: const Color(0xFFFFD54F),
        ),
        const SizedBox(width: 8),
        _MacroCard(
          label: 'Fat',
          value: state.totalFat,
          unit: 'g',
          color: const Color(0xFFEF9A9A),
        ),
      ],
    );
  }
}

class _MacroCard extends StatelessWidget {
  final String label;
  final double value;
  final String unit;
  final Color color;

  const _MacroCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(label,
                style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
            const SizedBox(height: 4),
            Text(
              '${value.toStringAsFixed(1)}$unit',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _MealSection extends StatelessWidget {
  final MealType meal;
  final List<FoodLog> logs;
  final WidgetRef ref;

  const _MealSection({required this.meal, required this.logs, required this.ref});

  @override
  Widget build(BuildContext context) {
    final totalCal = logs.fold(0.0, (s, f) => s + f.calories);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              meal.name[0].toUpperCase() + meal.name.substring(1),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Text('${totalCal.toStringAsFixed(0)} kcal',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: 8),
        ...logs.map((log) => _FoodLogRow(log: log, ref: ref)),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _FoodLogRow extends StatelessWidget {
  final FoodLog log;
  final WidgetRef ref;
  const _FoodLogRow({required this.log, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      // Swipe left to delete
      key: Key(log.id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (_) =>
          ref.read(calorieProvider.notifier).deleteLog(log.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: AppColors.danger.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_rounded, color: AppColors.danger),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(log.foodName,
                  style: Theme.of(context).textTheme.bodyLarge),
            ),
            Text('${log.calories.toStringAsFixed(0)} kcal',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final String label;
  final bool isNumber;

  const _InputField({
    required this.ctrl,
    required this.hint,
    required this.label,
    this.isNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textHint),
            filled: true,
            fillColor: AppColors.surfaceMuted,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}





