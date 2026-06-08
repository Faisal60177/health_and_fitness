import 'dart:math' as math;
import 'package:flutter/material.dart' hide StepState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../home/providers/step_provider.dart';
import 'step_goal_screen.dart';

class StepScreen extends ConsumerWidget {
  const StepScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(stepProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Steps',
            style: TextStyle(color: AppColors.textPrimary)),
        actions: [
          // Goal settings button — opens Image 2 screen
          IconButton(
            icon: const Icon(Icons.flag_rounded,
                color: AppColors.textSecondary),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const StepGoalScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Today's Walking Record Card ──────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.surfaceMuted),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Today\'s walking record',
                          style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 16)),
                      const Icon(Icons.chevron_right_rounded,
                          color: AppColors.textHint),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Semicircle progress arc (Image 1 style) ──
                  SizedBox(
                    height: 180,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: const Size(240, 180),
                          painter: _SemicircleArcPainter(
                            progress: step.progressPercent,
                            color: const Color(0xFFFFB300),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          child: Column(
                            children: [
                              const Text('Steps',
                                  style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 14)),
                              Text(
                                '${step.todaySteps}',
                                style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Slow / Brisk split (Image 1) ─────────────
                  _PaceSplitBar(state: step),

                  const SizedBox(height: 20),

                  // ── Distance + Calories row (Image 1) ────────
                  Row(
                    children: [
                      Expanded(
                        child: _StatPill(
                          label: 'Distance',
                          value:
                          '${step.distanceKm.toStringAsFixed(2)} km',
                        ),
                      ),
                      Container(width: 1, height: 40,
                          color: AppColors.surfaceMuted),
                      Expanded(
                        child: _StatPill(
                          label: 'Calories',
                          value:
                          '${step.caloriesBurned.toStringAsFixed(0)} kcal',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Goal progress card ────────────────────────────
            Container(
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
                      const Icon(Icons.flag_rounded,
                          color: Color(0xFFFFB300), size: 18),
                      const SizedBox(width: 8),
                      const Text('Daily goal',
                          style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const StepGoalScreen()),
                        ),
                        child: Text(
                          '${step.dailyGoal} steps',
                          style: const TextStyle(
                              color: Color(0xFFFFB300),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Icon(Icons.edit_rounded,
                          color: AppColors.textHint, size: 14),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: step.progressPercent,
                      minHeight: 10,
                      backgroundColor: AppColors.surfaceMuted,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFFFB300)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${step.todaySteps} steps',
                        style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12),
                      ),
                      Text(
                        '${(step.progressPercent * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                            color: Color(0xFFFFB300),
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Sensor status
            if (!step.sensorAvailable) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.warning.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_rounded,
                        color: AppColors.warning, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        step.errorMessage ??
                            'Step sensor unavailable on this device.',
                        style: const TextStyle(
                            color: AppColors.warning, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Test button for emulators
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => ref
                      .read(stepProvider.notifier)
                      .addTestSteps(500),
                  icon: const Icon(Icons.add_rounded,
                      color: AppColors.primary),
                  label: const Text('+500 steps (test)',
                      style: TextStyle(color: AppColors.primary)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Semicircle Arc Painter (Image 1 style) ────────────────────────
// Draws a half-circle progress arc like a speedometer
class _SemicircleArcPainter extends CustomPainter {
  final double progress;
  final Color  color;

  const _SemicircleArcPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 12;

    // Draw tick marks around the arc (Image 1 shows tick marks)
    final tickPaint = Paint()
      ..color      = AppColors.surfaceMuted
      ..strokeWidth = 2
      ..style      = PaintingStyle.stroke;

    const totalTicks = 30;
    for (int i = 0; i <= totalTicks; i++) {
      // Sweep from 180° to 0° (left to right semicircle)
      final angle  = math.pi + (i / totalTicks) * math.pi;
      final isLong = i % 5 == 0;
      final len    = isLong ? 14.0 : 8.0;

      final innerR = radius - len;
      final outerR = radius;

      // Color the active ticks yellow
      if (i / totalTicks <= progress) {
        tickPaint.color = color;
      } else {
        tickPaint.color = AppColors.surfaceMuted;
      }

      canvas.drawLine(
        Offset(center.dx + innerR * math.cos(angle),
            center.dy + innerR * math.sin(angle)),
        Offset(center.dx + outerR * math.cos(angle),
            center.dy + outerR * math.sin(angle)),
        tickPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_SemicircleArcPainter old) =>
      old.progress != progress;
}

// ── Slow / Brisk split bar ────────────────────────────────────────
class _PaceSplitBar extends StatelessWidget {
  final StepState state;
  const _PaceSplitBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final slowPct  = state.slowPercent;
    final briskPct = state.briskPercent;
    final total    = state.todaySteps;
    final slow     = state.slowSteps;
    final brisk    = state.briskSteps;

    return Column(
      children: [
        // Labels row
        Row(
          children: [
            Text('${slow}  ·  ${(slowPct * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12)),
            const Spacer(),
            Text('${brisk}  ·  ${(briskPct * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 6),

        // Split bar
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Row(
            children: [
              Expanded(
                flex: (slowPct  * 100).round().clamp(1, 99),
                child: Container(
                  height: 8,
                  color: const Color(0xFFFFB300).withOpacity(0.4),
                ),
              ),
              Expanded(
                flex: (briskPct * 100).round().clamp(1, 99),
                child: Container(
                  height: 8,
                  color: const Color(0xFFFF5722),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        // Pace labels
        const Row(
          children: [
            Text('Slow walking',
                style: TextStyle(
                    color: AppColors.textHint, fontSize: 11)),
            Spacer(),
            Text('Brisk walking',
                style: TextStyle(
                    color: AppColors.textHint, fontSize: 11)),
          ],
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  const _StatPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
      ],
    );
  }
}




