import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/workout_plan.dart';
import '../providers/workout_plan_provider.dart';
import 'plan_detail_screen.dart';

class WorkoutPlansScreen extends ConsumerWidget {
  const WorkoutPlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync   = ref.watch(workoutPlanProvider);
    final activePlanAsync = ref.watch(activePlanProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Workout Plans',
            style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active plan banner
            activePlanAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (plan) => plan != null
                  ? _ActivePlanBanner(plan: plan, ref: ref)
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 20),

            Text('Choose a plan',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 6),
            Text('Structured programs from beginner to advanced',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),

            // Templates grid
            plansAsync.when(
              loading: () =>
              const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Center(child: Text('Error: $e')),
              data: (plans) => Column(
                children: plans
                    .map((p) => _PlanCard(
                  plan: p,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlanDetailScreen(plan: p),
                    ),
                  ),
                ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivePlanBanner extends StatelessWidget {
  final WorkoutPlan plan;
  final WidgetRef ref;
  const _ActivePlanBanner({required this.plan, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.play_circle_rounded,
                  color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              const Text('Active Plan',
                  style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
              const Spacer(),
              Text(
                'Week ${plan.currentWeek} · Day ${plan.currentDay}',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(plan.name,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: plan.progressPercent,
              minHeight: 6,
              backgroundColor: AppColors.surfaceMuted,
              valueColor:
              const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(plan.progressPercent * 100).toStringAsFixed(0)}% complete',
            style: const TextStyle(
                fontSize: 11, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final WorkoutPlan plan;
  final VoidCallback onTap;
  const _PlanCard({required this.plan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final diffColor = plan.difficulty == 'beginner'
        ? AppColors.success
        : plan.difficulty == 'intermediate'
        ? AppColors.warning
        : AppColors.danger;

    final goalIcon = plan.goal == 'strength'
        ? Icons.fitness_center_rounded
        : plan.goal == 'fat_loss'
        ? Icons.local_fire_department_rounded
        : Icons.directions_run_rounded;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceMuted),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(goalIcon, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plan.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: diffColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          plan.difficulty[0].toUpperCase() +
                              plan.difficulty.substring(1),
                          style: TextStyle(
                              fontSize: 11, color: diffColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textHint),
              ],
            ),
            const SizedBox(height: 12),
            Text(plan.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            Row(
              children: [
                _PlanStat(
                    icon: Icons.calendar_today_rounded,
                    label: '${plan.durationWeeks} weeks'),
                const SizedBox(width: 16),
                _PlanStat(
                    icon: Icons.today_rounded,
                    label: '${plan.daysPerWeek} days/week'),
                const SizedBox(width: 16),
                _PlanStat(
                    icon: Icons.flag_rounded,
                    label: plan.goal.replaceAll('_', ' ')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanStat extends StatelessWidget {
  final IconData icon;
  final String label;
  const _PlanStat({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
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




