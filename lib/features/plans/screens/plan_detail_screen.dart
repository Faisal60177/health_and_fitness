import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/workout_plan.dart';
import '../providers/workout_plan_provider.dart';

class PlanDetailScreen extends ConsumerWidget {
  final WorkoutPlan plan;
  const PlanDetailScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(plan.name,
            style: const TextStyle(color: AppColors.textPrimary)),
        actions: [
          TextButton(
            onPressed: () async {
              await ref
                  .read(workoutPlanProvider.notifier)
                  .startPlan(plan);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Plan started! Check the Workout tab.'),
                    backgroundColor: AppColors.success,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Start plan',
                style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Plan overview
          Text(plan.description,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(height: 1.6)),
          const SizedBox(height: 20),

          // Stats row
          Row(
            children: [
              _StatBox(label: 'Duration',
                  value: '${plan.durationWeeks}wk'),
              _StatBox(label: 'Frequency',
                  value: '${plan.daysPerWeek}x/wk'),
              _StatBox(label: 'Level',
                  value: plan.difficulty[0].toUpperCase() +
                      plan.difficulty.substring(1)),
            ],
          ),

          const SizedBox(height: 24),

          Text('Weekly Schedule',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),

          // Day-by-day schedule
          ...plan.days.map((day) => _DayCard(day: day)),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceMuted),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold,
                    color: AppColors.primary)),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textHint)),
          ],
        ),
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final PlanDay day;
  const _DayCard({required this.day});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: day.isRestDay
            ? AppColors.surfaceCard.withOpacity(0.5)
            : AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: day.isRestDay
              ? AppColors.surfaceMuted.withOpacity(0.4)
              : AppColors.surfaceMuted,
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          day.dayLabel,
          style: TextStyle(
            color: day.isRestDay
                ? AppColors.textHint
                : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        trailing: day.isRestDay
            ? const Icon(Icons.hotel_rounded,
            color: AppColors.textHint, size: 18)
            : Text(
          '${day.exercises.length} exercises',
          style: const TextStyle(
              color: AppColors.textSecondary, fontSize: 12),
        ),
        children: day.isRestDay
            ? [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              'Active recovery: light walk, stretching, or mobility work.',
              style: TextStyle(
                  color: AppColors.textHint, fontSize: 13),
            ),
          ),
        ]
            : day.exercises
            .map((ex) => ListTile(
          dense: true,
          leading: Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.fitness_center_rounded,
                size: 16, color: AppColors.primary),
          ),
          title: Text(ex.exerciseName,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
          subtitle: Text(ex.muscleGroup,
              style: const TextStyle(
                  color: AppColors.textHint, fontSize: 11)),
          trailing: Text(
            '${ex.sets}×${ex.reps}',
            style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13),
          ),
        ))
            .toList(),
      ),
    );
  }
}




