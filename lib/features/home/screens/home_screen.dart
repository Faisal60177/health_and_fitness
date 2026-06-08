import 'dart:math' as math;
import 'package:flutter/material.dart' hide StepState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../dashboard/providers/dashboard_provider.dart';
import '../providers/step_provider.dart';
import 'package:health_and_fitness/features/water/providers/water_provider.dart';
import 'package:health_and_fitness/features/sleep/screens/sleep_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardSummaryProvider);
    final stepState      = ref.watch(stepProvider);
    final waterAsync     = ref.watch(waterProvider);
    final isDark         = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.background : AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${_getGreeting()} 👋',
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text('Today\'s Overview',
                            style: Theme.of(context).textTheme.headlineLarge),
                      ],
                    ),
                  ),
                  // Streak badge
                  dashboardAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (dash) => _StreakBadge(days: dash.currentStreak),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Three concentric progress rings — the centrepiece
              Center(
                child: dashboardAsync.when(
                  loading: () => const SizedBox(
                    width: 220,
                    height: 220,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (dash) => _TripleRing(summary: dash, stepState: stepState),
                ),
              ),

              const SizedBox(height: 12),

              // Centered Ring Legend
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _RingLegend(color: AppColors.primary, label: 'Steps'),
                  SizedBox(width: 16),
                  _RingLegend(color: AppColors.calorieOrange, label: 'Calories'),
                  SizedBox(width: 16),
                  _RingLegend(color: AppColors.waterBlue, label: 'Water'),
                ],
              ),

              const SizedBox(height: 28),

              // Stats grid — 2×2
              dashboardAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (dash) => _StatsGrid(summary: dash),
              ),

              const SizedBox(height: 20),

              // Water quick-log card
              waterAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (water) => _WaterQuickCard(state: water, ref: ref),
              ),

              const SizedBox(height: 20),

              // Quick navigation cards
              const _QuickNav(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Ring Legend Element ──────────────────────
class _RingLegend extends StatelessWidget {
  final Color color;
  final String label;
  const _RingLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}

// ─── Triple Progress Ring ─────────────────────
class _TripleRing extends StatelessWidget {
  final DashboardSummary summary;
  final StepState stepState;
  const _TripleRing({required this.summary, required this.stepState});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(220, 220),
            painter: _RingPainter(
              outerProgress: stepState.progressPercent,
              midProgress: summary.calorieProgress,
              innerProgress: summary.waterProgress,
              trackColor: isDark ? AppColors.surfaceMuted : AppColors.surfaceMutedLight,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${stepState.todaySteps}',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight),
              ),
              Text(
                'steps',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.textHint : AppColors.textHintLight,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(stepState.progressPercent * 100).toStringAsFixed(0)}% of goal',
                  style: const TextStyle(fontSize: 11, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double outerProgress;
  final double midProgress;
  final double innerProgress;
  final Color trackColor;

  const _RingPainter({
    required this.outerProgress,
    required this.midProgress,
    required this.innerProgress,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const stroke = 16.0;
    const gap = 10.0;

    _drawRing(canvas, center, size.width / 2 - stroke / 2,
        stroke, outerProgress, AppColors.primary, trackColor);

    _drawRing(canvas, center, size.width / 2 - stroke / 2 - stroke - gap,
        stroke, midProgress, AppColors.calorieOrange, trackColor);

    _drawRing(canvas, center, size.width / 2 - stroke / 2 - (stroke + gap) * 2,
        stroke, innerProgress, AppColors.waterBlue, trackColor);
  }

  void _drawRing(Canvas canvas, Offset center, double radius,
      double strokeWidth, double progress, Color color, Color track) {
    final trackPaint = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi, false, trackPaint);

    if (progress > 0) {
      canvas.drawArc(rect, -math.pi / 2,
          2 * math.pi * progress.clamp(0.0, 1.0), false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.outerProgress != outerProgress ||
          old.midProgress != midProgress ||
          old.innerProgress != innerProgress ||
          old.trackColor != trackColor;
}

// ─── Stats Grid ───────────────────────────────
class _StatsGrid extends StatelessWidget {
  final DashboardSummary summary;
  const _StatsGrid({required this.summary});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.7,
      children: [
        _GridCard(
          icon: Icons.local_fire_department_rounded,
          label: 'Calories',
          value: summary.todayCalories.toStringAsFixed(0),
          unit: 'kcal',
          color: AppColors.calorieOrange,
          progress: summary.calorieProgress,
        ),
        _GridCard(
          icon: Icons.water_drop_rounded,
          label: 'Water',
          value: '${summary.todayWaterMl}',
          unit: 'ml',
          color: AppColors.waterBlue,
          progress: summary.waterProgress,
        ),
        _GridCard(
          icon: Icons.fitness_center_rounded,
          label: 'Workouts',
          value: '${summary.workoutsThisWeek}',
          unit: 'this week',
          color: AppColors.workoutPurple,
          progress: (summary.workoutsThisWeek / 5).clamp(0.0, 1.0),
        ),
        _GridCard(
          icon: Icons.bedtime_rounded,
          label: 'Sleep',
          value: summary.lastSleepHours != null
              ? summary.lastSleepHours!.toStringAsFixed(1)
              : '--',
          unit: 'hours',
          color: AppColors.sleepDeepPurple,
          progress: summary.lastSleepHours != null
              ? (summary.lastSleepHours! / 8).clamp(0.0, 1.0)
              : 0,
        ),
      ],
    );
  }
}

class _GridCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color color;
  final double progress;

  const _GridCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceCard : AppColors.surfaceCardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.surfaceMuted : AppColors.surfaceMutedLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AppColors.textHint : AppColors.textHintLight,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(width: 3),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: color.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Streak Badge ─────────────────────────────
class _StreakBadge extends StatelessWidget {
  final int days;
  const _StreakBadge({required this.days});

  @override
  Widget build(BuildContext context) {
    if (days == 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.calorieOrange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.calorieOrange.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            '$days day streak',
            style: const TextStyle(
                fontSize: 12,
                color: AppColors.calorieOrange,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ─── Water Quick Log ──────────────────────────
class _WaterQuickCard extends StatelessWidget {
  final WaterState state;
  final WidgetRef ref;
  const _WaterQuickCard({required this.state, required this.ref});

  @override
  Widget build(BuildContext context) {
    final quickAmounts = [150, 250, 350, 500];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceCard : AppColors.surfaceCardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.surfaceMuted : AppColors.surfaceMutedLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.water_drop_rounded, color: AppColors.waterBlue, size: 16),
              const SizedBox(width: 8),
              Text('Water intake', style: Theme.of(context).textTheme.bodyMedium),
              const Spacer(),
              Text(
                '${state.totalMl} / ${state.dailyGoalMl} ml',
                style: const TextStyle(
                    color: AppColors.waterBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: state.progress,
              minHeight: 6,
              backgroundColor: isDark ? AppColors.surfaceMuted : AppColors.surfaceMutedLight,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.waterBlue),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: quickAmounts.map((ml) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: GestureDetector(
                  onTap: () => ref.read(waterProvider.notifier).addWater(ml),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.waterBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.waterBlue.withOpacity(0.3)),
                    ),
                    child: Text(
                      '+${ml}ml',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.waterBlue,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

// ─── Quick Navigation Grid ───
class _QuickNav extends StatelessWidget {
  const _QuickNav();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick access',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickNavCard(
                icon: Icons.directions_walk_rounded,
                label: 'Steps',
                color: const Color(0xFFFFB300),
                onTap: () => context.go(AppRoutes.steps),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _QuickNavCard(
                icon: Icons.show_chart_rounded,
                label: 'Charts',
                color: AppColors.primary,
                onTap: () => context.go(AppRoutes.charts),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _QuickNavCard(
                icon: Icons.ios_share_rounded,
                label: 'Export',
                color: AppColors.workoutPurple,
                onTap: () => context.go(AppRoutes.export),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _QuickNavCard(
                icon: Icons.bedtime_rounded,
                label: 'Sleep',
                color: AppColors.sleepDeepPurple,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SleepScreen()),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickNavCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickNavCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}