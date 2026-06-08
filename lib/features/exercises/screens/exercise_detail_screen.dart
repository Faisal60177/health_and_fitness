import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/local_exercise.dart';

class ExerciseDetailScreen extends ConsumerWidget {
  final LocalExercise exercise;
  const ExerciseDetailScreen(
      {super.key, required this.exercise});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final color = _categoryColor(exercise.category);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero header — icon instead of GIF
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.surfaceCard,
            iconTheme:
            const IconThemeData(color: AppColors.textPrimary),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: color.withOpacity(0.08),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 48),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withOpacity(0.15),
                        border: Border.all(
                            color: color.withOpacity(0.4),
                            width: 2),
                      ),
                      child: Icon(_categoryIcon(exercise.category),
                          color: color, size: 48),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        exercise.category,
                        style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
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
                // Name
                Text(
                  exercise.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),

                // Equipment + category chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InfoChip(
                      label: exercise.category,
                      icon: Icons.category_rounded,
                      color: color,
                    ),
                    _InfoChip(
                      label: exercise.equipment,
                      icon: Icons.fitness_center_rounded,
                      color: const Color(0xFFA78BFA),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Primary muscles
                if (exercise.muscles.isNotEmpty) ...[
                  _SectionHeader('Primary Muscles'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: exercise.muscles
                        .map((m) => _InfoChip(
                      label: m,
                      icon:
                      Icons.accessibility_new_rounded,
                      color: const Color(0xFFFF7043),
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // Secondary muscles
                if (exercise.musclesSecondary.isNotEmpty) ...[
                  _SectionHeader('Secondary Muscles'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: exercise.musclesSecondary
                        .map((m) => _InfoChip(
                      label: m,
                      icon: Icons.accessibility_rounded,
                      color: AppColors.textSecondary,
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // Instructions
                _SectionHeader('Instructions'),
                const SizedBox(height: 12),
                ..._parseInstructions(exercise.description)
                    .asMap()
                    .entries
                    .map((e) => _StepRow(
                  number: e.key + 1,
                  text: e.value,
                )),

                const SizedBox(height: 32),

                // Back button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Back to exercises'),
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
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // Split description into numbered steps by period or newline
  List<String> _parseInstructions(String description) {
    if (description.isEmpty) return ['No instructions available.'];
    final steps = description
        .split(RegExp(r'\.\s+|\n'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    // Ensure each step ends with a period
    return steps
        .map((s) => s.endsWith('.') ? s : '$s.')
        .toList();
  }
}

// ── Reusable widgets ──────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _InfoChip(
      {required this.label,
        required this.icon,
        required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final int number;
  final String text;
  const _StepRow({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            margin: const EdgeInsets.only(right: 12, top: 1),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}




