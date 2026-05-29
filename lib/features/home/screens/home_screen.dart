import 'dart:math' as math;
import 'package:flutter/material.dart' hide StepState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../dashboard/providers/dashboard_provider.dart';
import '../providers/step_provider.dart';
import 'package:health_and_fitness/features/water/providers/water_provider.dart';
import 'package:health_and_fitness/features/dashboard/providers/analytics_provider.dart';
import 'package:health_and_fitness/features/dashboard/screens/analytics_screen.dart';
import 'package:health_and_fitness/features/sleep/screens/sleep_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardSummaryProvider);
    final stepState      = ref.watch(stepNotifierProvider);
    final waterAsync     = ref.watch(waterNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
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
                        Text('Good morning 👋',
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
                    width: 220, height: 220,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (dash) => _TripleRing(summary: dash, stepState: stepState),
                ),
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

// ─── Triple Progress Ring ─────────────────────
// Custom painter draws 3 concentric arcs
// Outer = steps, Middle = calories, Inner = water
class _TripleRing extends StatelessWidget {
  final DashboardSummary summary;
  final StepState stepState;
  const _TripleRing({required this.summary, required this.stepState});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The three arcs drawn by CustomPainter
          CustomPaint(
            size: const Size(220, 220),
            painter: _RingPainter(
              outerProgress: stepState.progressPercent,   // steps
              midProgress: summary.calorieProgress,        // calories
              innerProgress: summary.waterProgress,        // water
            ),
          ),

          // Centre text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${stepState.todaySteps}',
                style: const TextStyle(
                    fontSize: 30, fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
              const Text('steps',
                  style: TextStyle(
                      fontSize: 12, color: AppColors.textHint)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(stepState.progressPercent * 100).toStringAsFixed(0)}% of goal',
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.primary),
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
  final double outerProgress; // steps — green
  final double midProgress;   // calories — orange
  final double innerProgress; // water — blue

  const _RingPainter({
    required this.outerProgress,
    required this.midProgress,
    required this.innerProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const stroke = 16.0;
    const gap = 10.0;

    // Draw track then progress arc for each ring
    _drawRing(canvas, center, size.width / 2 - stroke / 2,
        stroke, outerProgress, AppColors.primary,
        AppColors.surfaceMuted);

    _drawRing(canvas, center, size.width / 2 - stroke / 2 - stroke - gap,
        stroke, midProgress, const Color(0xFFFF7043),
        AppColors.surfaceMuted);

    _drawRing(canvas, center, size.width / 2 - stroke / 2 - (stroke + gap) * 2,
        stroke, innerProgress, const Color(0xFF42A5F5),
        AppColors.surfaceMuted);
  }

  void _drawRing(Canvas canvas, Offset center, double radius,
      double strokeWidth, double progress, Color color, Color trackColor) {
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Full track circle
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi, false, trackPaint);

    // Progress arc — starts at top (-π/2), sweeps clockwise
    if (progress > 0) {
      canvas.drawArc(rect, -math.pi / 2,
          2 * math.pi * progress.clamp(0.0, 1.0), false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.outerProgress != outerProgress ||
          old.midProgress != midProgress ||
          old.innerProgress != innerProgress;
}

// ─── Ring Legend / Stats Grid ─────────────────
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
          value: '${summary.todayCalories.toStringAsFixed(0)}',
          unit: 'kcal',
          color: const Color(0xFFFF7043),
          progress: summary.calorieProgress,
        ),
        _GridCard(
          icon: Icons.water_drop_rounded,
          label: 'Water',
          value: '${summary.todayWaterMl}',
          unit: 'ml',
          color: const Color(0xFF42A5F5),
          progress: summary.waterProgress,
        ),
        _GridCard(
          icon: Icons.fitness_center_rounded,
          label: 'Workouts',
          value: '${summary.workoutsThisWeek}',
          unit: 'this week',
          color: const Color(0xFFA78BFA),
          progress: (summary.workoutsThisWeek / 5).clamp(0.0, 1.0),
        ),
        _GridCard(
          icon: Icons.bedtime_rounded,
          label: 'Sleep',
          value: summary.lastSleepHours != null
              ? summary.lastSleepHours!.toStringAsFixed(1)
              : '--',
          unit: 'hours',
          color: const Color(0xFF7C3AED),
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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(label,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textHint)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(width: 3),
              Text(unit, style: const TextStyle(
                  fontSize: 10, color: AppColors.textSecondary)),
            ],
          ),
          // Mini progress bar at bottom of card
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
        color: const Color(0xFFFF7043).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFF7043).withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text('$days day streak',
              style: const TextStyle(
                  fontSize: 12, color: Color(0xFFFF7043),
                  fontWeight: FontWeight.w600)),
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
    return Container(
      padding: const EdgeInsets.all(16),
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
              const Icon(Icons.water_drop_rounded,
                  color: Color(0xFF42A5F5), size: 16),
              const SizedBox(width: 8),
              Text('Water intake',
                  style: Theme.of(context).textTheme.bodyMedium),
              const Spacer(),
              Text(
                '${state.totalMl} / ${state.dailyGoalMl} ml',
                style: const TextStyle(
                    color: Color(0xFF42A5F5),
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
              backgroundColor: AppColors.surfaceMuted,
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF42A5F5)),
            ),
          ),
          const SizedBox(height: 12),
          // Quick-add buttons
          Row(
            children: quickAmounts.map((ml) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: GestureDetector(
                  onTap: () => ref
                      .read(waterNotifierProvider.notifier)
                      .addWater(ml),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF42A5F5).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: const Color(0xFF42A5F5).withOpacity(0.3)),
                    ),
                    child: Text(
                      '+${ml}ml',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF42A5F5),
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

// ─── Quick Navigation Grid ────────────────────
class _QuickNav extends StatelessWidget {

  const _QuickNav();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick access',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Row(
          children: [
            _QuickNavCard(
              icon:  Icons.directions_walk_rounded,
              label: 'Steps',
              color: const Color(0xFFFFB300),
              onTap: () => context.go(AppRoutes.steps),
            ),
            _QuickNavCard(
              icon: Icons.show_chart_rounded,
              label: 'Charts',
              color: AppColors.primary,
              onTap: () => context.go(AppRoutes.charts),
            ),
            const SizedBox(width: 12),
            _QuickNavCard(
              icon: Icons.ios_share_rounded,
              label: 'Export',
              color: const Color(0xFFA78BFA),
              onTap: () => context.go(AppRoutes.export),
            ),
            const SizedBox(width: 12),
            _QuickNavCard(
              icon: Icons.bedtime_rounded,
              label: 'Sleep',
              color: const Color(0xFF7C3AED),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SleepScreen())),
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
  const _QuickNavCard({required this.icon, required this.label,
    required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.25)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(label,
                  style: TextStyle(
                      fontSize: 12, color: color,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
