import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/local_exercise.dart';
import '../../../data/services/local_exercise_service.dart';
import '../providers/exercise_provider.dart';
import 'exercise_detail_screen.dart';

class ExerciseDatabaseScreen extends ConsumerStatefulWidget {
  const ExerciseDatabaseScreen({super.key});

  @override
  ConsumerState<ExerciseDatabaseScreen> createState() =>
      _ExerciseDatabaseScreenState();
}

class _ExerciseDatabaseScreenState
    extends ConsumerState<ExerciseDatabaseScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(exerciseNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Exercise Database',
            style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                hintStyle: const TextStyle(color: AppColors.textHint),
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColors.textHint),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear_rounded,
                      color: AppColors.textHint),
                  onPressed: () {
                    _searchController.clear();
                    ref
                        .read(exerciseNotifierProvider.notifier)
                        .clearSearch();
                  },
                )
                    : null,
                filled: true,
                fillColor: AppColors.surfaceMuted,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (q) {
                setState(() {}); // update clear button visibility
                ref.read(exerciseNotifierProvider.notifier).search(q);
              },
            ),
          ),

          // Category filter chips
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _CategoryChip(
                  label: 'All',
                  isSelected: state.selectedCategory == null,
                  onTap: () => ref
                      .read(exerciseNotifierProvider.notifier)
                      .loadExercises(),
                ),
                ...LocalExerciseService.categories.map(
                      (cat) => _CategoryChip(
                    label: cat,
                    isSelected: state.selectedCategory == cat,
                    onTap: () => ref
                        .read(exerciseNotifierProvider.notifier)
                        .loadExercises(category: cat),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Exercise count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${state.exercises.length} exercises',
                  style: const TextStyle(
                      color: AppColors.textHint, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // Exercise list
          Expanded(
            child: state.exercises.isEmpty
                ? _EmptyState(searchTerm: state.searchTerm)
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.exercises.length,
              itemBuilder: (ctx, i) => _ExerciseListTile(
                exercise: state.exercises[i],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExerciseDetailScreen(
                      exercise: state.exercises[i],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Category chip ─────────────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
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
  }
}

// ── Exercise list tile ────────────────────────────────────────────────────────

class _ExerciseListTile extends StatelessWidget {
  final LocalExercise exercise;
  final VoidCallback onTap;

  const _ExerciseListTile(
      {required this.exercise, required this.onTap});

  // Consistent color per category
  Color _categoryColor(String cat) {
    switch (cat) {
      case 'Chest':     return const Color(0xFFFF7043);
      case 'Back':      return const Color(0xFF42A5F5);
      case 'Shoulders': return const Color(0xFFA78BFA);
      case 'Arms':      return const Color(0xFFFFD54F);
      case 'Legs':      return AppColors.primary;
      case 'Core':      return const Color(0xFFFF8F00);
      case 'Cardio':    return const Color(0xFFEF5350);
      default:          return AppColors.textSecondary;
    }
  }

  // Icon per category
  IconData _categoryIcon(String cat) {
    switch (cat) {
      case 'Chest':     return Icons.sports_gymnastics_rounded;
      case 'Back':      return Icons.airline_seat_recline_extra_rounded;
      case 'Shoulders': return Icons.accessibility_rounded;
      case 'Arms':      return Icons.fitness_center_rounded;
      case 'Legs':      return Icons.directions_run_rounded;
      case 'Core':      return Icons.radio_button_checked_rounded;
      case 'Cardio':    return Icons.favorite_rounded;
      default:          return Icons.fitness_center_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor(exercise.category);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.surfaceMuted),
        ),
        child: Row(
          children: [
            // Category icon box — replaces gif thumbnail
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(14),
                ),
              ),
              child: Icon(_categoryIcon(exercise.category),
                  color: color, size: 32),
            ),

            // Exercise info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _MuscleChip(exercise.category,
                            color: color),
                        const SizedBox(width: 6),
                        if (exercise.equipment.isNotEmpty)
                          _MuscleChip(exercise.equipment,
                              color: AppColors.textSecondary),
                      ],
                    ),
                    if (exercise.muscles.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        exercise.muscles.take(2).join(' · '),
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textHint),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right_rounded,
                  color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }
}

class _MuscleChip extends StatelessWidget {
  final String label;
  final Color color;
  const _MuscleChip(this.label, {required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 10,
            color: color,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String searchTerm;
  const _EmptyState({required this.searchTerm});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded,
              size: 48, color: AppColors.textHint),
          const SizedBox(height: 12),
          Text(
            searchTerm.isEmpty
                ? 'No exercises found'
                : 'No results for "$searchTerm"',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}