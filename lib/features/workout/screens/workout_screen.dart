import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/workout_log.dart';
import '../../../data/models/workout_plan.dart';
import '../../../data/repositories/workout_plan_repository.dart';
import '../../../data/services/local_exercise_service.dart';
import '../providers/workout_provider.dart';
import 'package:health_and_fitness/features/plans/providers/workout_plan_provider.dart';
import 'package:health_and_fitness/core/router/app_router.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────
// Workout Screen
// ─────────────────────────────────────────────
class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync  = ref.watch(workoutNotifierProvider);
    final activeWorkout  = ref.watch(activeWorkoutProvider);
    final activePlanAsync = ref.watch(activePlanProvider);

    // Responsive sizing
    final sw = MediaQuery.of(context).size.width;
    final isSmall = sw < 360;
    final hPad   = sw * 0.05;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────
              Text('Workouts',
                  style: Theme.of(context).textTheme.headlineLarge
                      ?.copyWith(fontSize: isSmall ? 22 : null)),
              const SizedBox(height: 4),
              Text('Track your training sessions',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),

              // ── In-progress session banner ───────────────────
              if (activeWorkout != null) ...[
                _ActiveWorkoutBanner(session: activeWorkout),
                const SizedBox(height: 12),
              ],

              // ── Active plan banner ───────────────────────────
              activePlanAsync.when(
                loading: () => const SizedBox.shrink(),
                error:   (_, __) => const SizedBox.shrink(),
                data: (plan) => plan != null
                    ? _ActivePlanBanner(plan: plan)
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 12),

              // ── Start workout button ─────────────────────────
              SizedBox(
                width: double.infinity,
                height: isSmall ? 44 : 50,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      _showStartWorkoutDialog(context, ref),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Start new workout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ── Quick links ──────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _QuickLink(
                      icon:  Icons.list_alt_rounded,
                      label: 'Workout Plans',
                      color: const Color(0xFFA78BFA),
                      onTap: () => context.go(AppRoutes.plans),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickLink(
                      icon:  Icons.search_rounded,
                      label: 'Exercise DB',
                      color: AppColors.primary,
                      onTap: () => context.go(AppRoutes.exercises),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Text('Recent sessions',
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),

              // ── Session list ─────────────────────────────────
              Expanded(
                child: sessionsAsync.when(
                  loading: () => const Center(
                      child: CircularProgressIndicator()),
                  error: (e, _) =>
                      Center(child: Text('Error: $e')),
                  data: (sessions) => sessions.isEmpty
                      ? const _EmptyState()
                      : ListView.builder(
                    itemCount: sessions.length,
                    itemBuilder: (ctx, i) => Dismissible(
                      key: Key(sessions[i].id.toString()),
                      direction:
                      DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(
                            right: 20),
                        margin: const EdgeInsets.only(
                            bottom: 12),
                        decoration: BoxDecoration(
                          color: AppColors.danger
                              .withOpacity(0.85),
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                        child: const Icon(
                            Icons.delete_rounded,
                            color: Colors.white,
                            size: 22),
                      ),
                      onDismissed: (_) => ref
                          .read(workoutNotifierProvider
                          .notifier)
                          .deleteSession(sessions[i].id),
                      child: _SessionCard(
                          session: sessions[i]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStartWorkoutDialog(
      BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          24, 24, 24,
          MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name your workout',
                style:
                Theme.of(ctx).textTheme.headlineMedium),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              autofocus: true,
              style: const TextStyle(
                  color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'e.g. Push Day, Leg Day…',
                hintStyle: const TextStyle(
                    color: AppColors.textHint),
                filled: true,
                fillColor: AppColors.surfaceMuted,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final name = nameCtrl.text.trim();
                  if (name.isEmpty) return;
                  ref
                      .read(activeWorkoutProvider.notifier)
                      .start(name);
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const ActiveWorkoutScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Start workout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Active plan banner (tappable) ─────────────────────────────────────────────
class _ActivePlanBanner extends ConsumerWidget {
  final WorkoutPlan plan;
  const _ActivePlanBanner({required this.plan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.go(AppRoutes.plans),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFA78BFA).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: const Color(0xFFA78BFA).withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.list_alt_rounded,
                color: Color(0xFFA78BFA), size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Active Plan',
                      style: TextStyle(
                          color: Color(0xFFA78BFA),
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                  Text(plan.name,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Wk ${plan.currentWeek} · Day ${plan.currentDay}',
                    style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11)),
                const SizedBox(height: 4),
                SizedBox(
                  width: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: plan.progressPercent,
                      minHeight: 5,
                      backgroundColor: AppColors.surfaceMuted,
                      valueColor:
                      const AlwaysStoppedAnimation<Color>(
                          Color(0xFFA78BFA)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── In-progress workout banner ────────────────────────────────────────────────
class _ActiveWorkoutBanner extends StatelessWidget {
  final WorkoutSession session;
  const _ActiveWorkoutBanner({required this.session});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => const ActiveWorkoutScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: AppColors.primary.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            const Icon(Icons.fitness_center_rounded,
                color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(session.name,
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                  Text(
                      '${session.exercises.length} exercises · in progress',
                      style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Continue',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Session card ──────────────────────────────────────────────────────────────
class _SessionCard extends StatelessWidget {
  final WorkoutSession session;
  const _SessionCard({required this.session});

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(session.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis),
              ),
              Text(_formatDate(session.date),
                  style: const TextStyle(
                      color: AppColors.textHint,
                      fontSize: 11)),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _Chip(
                  icon: Icons.fitness_center_rounded,
                  label:
                  '${session.exercises.length} exercises'),
              _Chip(
                  icon: Icons.timer_rounded,
                  label: '${session.durationMinutes} min'),
              _Chip(
                  icon: Icons.bar_chart_rounded,
                  label:
                  '${session.totalVolume.toStringAsFixed(0)} kg'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fitness_center_rounded,
              size: 56, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text('No workouts yet',
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 4),
          Text('Start your first session above',
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _QuickLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickLink(
      {required this.icon,
        required this.label,
        required this.color,
        required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Active Workout Screen
// ─────────────────────────────────────────────
class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  ConsumerState<ActiveWorkoutScreen> createState() =>
      _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState
    extends ConsumerState<ActiveWorkoutScreen> {
  final _stopwatch = Stopwatch()..start();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Tick every second to update the live timer display
    _timer = Timer.periodic(
        const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(activeWorkoutProvider);
    if (session == null) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => Navigator.pop(context));
      return const SizedBox.shrink();
    }

    final sw     = MediaQuery.of(context).size.width;
    final hPad   = sw * 0.05;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(session.name,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            // ── Live timer ──────────────────────────────
            Text(
              _formatDuration(_stopwatch.elapsed),
              style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => _finishWorkout(session),
            child: const Text('Finish',
                style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: hPad, vertical: 12),
        child: Column(
          children: [
            // ── Add exercise button ──────────────────────
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () =>
                    _showAddExerciseDialog(context),
                icon: const Icon(Icons.add_rounded,
                    color: AppColors.primary),
                label: const Text('Add exercise',
                    style: TextStyle(
                        color: AppColors.primary)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                      color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(
                      vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Exercise list ────────────────────────────
            Expanded(
              child: session.exercises.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline_rounded,
                        size: 48,
                        color: AppColors.textHint),
                    const SizedBox(height: 12),
                    Text('Add your first exercise',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: session.exercises.length,
                itemBuilder: (ctx, i) => _ExerciseCard(
                  exercise: session.exercises[i],
                  exerciseIndex: i,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Full exercise DB picker with search ──────────────────
  void _showAddExerciseDialog(BuildContext context) {
    final exercises = LocalExerciseService.getExercises();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        String search = '';
        return StatefulBuilder(
          builder: (ctx, setState) {
            final filtered = search.isEmpty
                ? exercises
                : exercises
                .where((e) => e.name
                .toLowerCase()
                .contains(search.toLowerCase()))
                .toList();

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.7,
              maxChildSize: 0.95,
              builder: (_, controller) => Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius:
                      BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        16, 12, 16, 8),
                    child: TextField(
                      autofocus: true,
                      style: const TextStyle(
                          color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search exercises…',
                        hintStyle: const TextStyle(
                            color: AppColors.textHint),
                        prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: AppColors.textHint),
                        filled: true,
                        fillColor: AppColors.surfaceMuted,
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(
                            vertical: 10),
                      ),
                      onChanged: (v) =>
                          setState(() => search = v),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16),
                    child: Text(
                        '${filtered.length} exercises',
                        style: const TextStyle(
                            color: AppColors.textHint,
                            fontSize: 11)),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: filtered.length,
                      itemBuilder: (ctx, i) {
                        final ex = filtered[i];
                        return ListTile(
                          leading: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: AppColors.primary
                                  .withOpacity(0.1),
                              borderRadius:
                              BorderRadius.circular(
                                  10),
                            ),
                            child: const Icon(
                                Icons
                                    .fitness_center_rounded,
                                size: 16,
                                color: AppColors.primary),
                          ),
                          title: Text(ex.name,
                              style: const TextStyle(
                                  color: AppColors
                                      .textPrimary,
                                  fontSize: 13,
                                  fontWeight:
                                  FontWeight.w500)),
                          subtitle: Text(
                              '${ex.category} · ${ex.equipment}',
                              style: const TextStyle(
                                  color: AppColors
                                      .textSecondary,
                                  fontSize: 11)),
                          onTap: () {
                            ref
                                .read(activeWorkoutProvider
                                .notifier)
                                .addExercise(
                                ex.name, ex.category);
                            Navigator.pop(ctx);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ── Finish workout with guards + plan advancement ─────────
  Future<void> _finishWorkout(WorkoutSession session) async {
    // Guard: empty workout
    if (session.exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
          Text('Add at least one exercise before finishing.'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    final finalSession = WorkoutSession()
      ..id              = session.id
      ..name            = session.name
      ..date            = session.date
      ..durationMinutes = DateTime.now()
          .difference(session.date)
          .inMinutes
          .clamp(1, 999)
      ..exercises       = session.exercises;

    await ref
        .read(workoutNotifierProvider.notifier)
        .addSession(finalSession);

    ref.read(activeWorkoutProvider.notifier).clear();

    // Plan advancement dialog
    if (mounted) {
      final activePlan =
      await WorkoutPlanRepository().getActivePlan();
      if (activePlan != null && mounted) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppColors.surfaceCard,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: const Text('Great workout! 💪',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16)),
            content: Text(
              'Mark Day ${activePlan.currentDay} of "${activePlan.name}" complete?',
              style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Skip',
                    style: TextStyle(
                        color: AppColors.textHint)),
              ),
              ElevatedButton(
                onPressed: () async {
                  await WorkoutPlanRepository()
                      .advanceDay(activePlan);
                  ref.invalidate(activePlanProvider);
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Mark complete'),
              ),
            ],
          ),
        );
      }
    }

    if (mounted) Navigator.pop(context);
  }
}

// ── Exercise card with sets ───────────────────────────────────────────────────
class _ExerciseCard extends ConsumerWidget {
  final WorkoutExercise exercise;
  final int exerciseIndex;

  const _ExerciseCard({
    required this.exercise,
    required this.exerciseIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sw = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise header
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                    Icons.fitness_center_rounded,
                    size: 16,
                    color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(exercise.name,
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                        overflow: TextOverflow.ellipsis),
                    Text(exercise.muscleGroup,
                        style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                  AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${exercise.totalVolume.toStringAsFixed(0)} kg',
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ),
            ],
          ),

          if (exercise.sets.isNotEmpty) ...[
            const SizedBox(height: 12),
            // Column headers
            Row(
              children: [
                SizedBox(
                    width: 32,
                    child: Text('Set',
                        style: _headerStyle())),
                Expanded(
                    child: Text('Weight',
                        style: _headerStyle())),
                Expanded(
                    child: Text('Reps',
                        style: _headerStyle())),
                SizedBox(
                    width: sw * 0.12,
                    child: Text('Vol',
                        style: _headerStyle(),
                        textAlign: TextAlign.right)),
              ],
            ),
            const SizedBox(height: 4),
            ...exercise.sets.asMap().entries.map(
                  (e) => _SetRow(
                setNum: e.key + 1,
                set: e.value,
                screenWidth: sw,
              ),
            ),
          ],

          const SizedBox(height: 8),
          // Add set button
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () =>
                  _showAddSetDialog(context, ref),
              icon: const Icon(Icons.add_rounded,
                  size: 16, color: AppColors.primary),
              label: const Text('Add set',
                  style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13)),
              style: TextButton.styleFrom(
                backgroundColor:
                AppColors.primary.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _headerStyle() => const TextStyle(
      fontSize: 11,
      color: AppColors.textHint,
      fontWeight: FontWeight.w500);

  void _showAddSetDialog(BuildContext context, WidgetRef ref) {
    double weight = 20;
    int reps = 10;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: AppColors.surfaceCard,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          title: Text('${exercise.name} — Add set',
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SliderRow(
                label:
                'Weight: ${weight.toStringAsFixed(1)} kg',
                value: weight,
                min: 0,
                max: 300,
                divisions: 600,
                onChanged: (v) =>
                    setState(() => weight = v),
              ),
              const SizedBox(height: 12),
              _SliderRow(
                label: 'Reps: $reps',
                value: reps.toDouble(),
                min: 1,
                max: 50,
                divisions: 49,
                onChanged: (v) =>
                    setState(() => reps = v.round()),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(
                      color: AppColors.textHint)),
            ),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(
                    activeWorkoutProvider.notifier)
                    .addSet(
                  exerciseIndex,
                  WorkoutSet.create(
                      weightKg: weight, reps: reps),
                );
                Navigator.pop(ctx);
                // ── Rest timer after saving set ──────
                _showRestTimer(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Save set'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Rest timer dialog ──────────────────────────────────────
  void _showRestTimer(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const _RestTimerDialog(seconds: 90),
    );
  }
}

// ── Slider row helper ─────────────────────────────────────────────────────────
class _SliderRow extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13)),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.surfaceMuted,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// ── Set row ───────────────────────────────────────────────────────────────────
class _SetRow extends StatelessWidget {
  final int setNum;
  final WorkoutSet set;
  final double screenWidth;

  const _SetRow({
    required this.setNum,
    required this.set,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final vol = set.weightKg * set.reps;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: AppColors.surfaceMuted.withOpacity(0.5),
              width: 0.5),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text('$setNum',
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary)),
              ),
            ),
          ),
          Expanded(
            child: Text('${set.weightKg} kg',
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 13)),
          ),
          Expanded(
            child: Text('${set.reps} reps',
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13)),
          ),
          SizedBox(
            width: screenWidth * 0.12,
            child: Text(
              '${vol.toStringAsFixed(0)} kg',
              style: const TextStyle(
                  color: AppColors.textHint, fontSize: 11),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Rest timer dialog ─────────────────────────────────────────────────────────
class _RestTimerDialog extends StatefulWidget {
  final int seconds;
  const _RestTimerDialog({required this.seconds});

  @override
  State<_RestTimerDialog> createState() =>
      _RestTimerDialogState();
}

class _RestTimerDialogState extends State<_RestTimerDialog> {
  late int _remaining;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _remaining = widget.seconds;
    _t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining <= 1) {
        _t?.cancel();
        if (mounted) Navigator.pop(context);
      } else {
        setState(() => _remaining--);
      }
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  String get _label {
    final m = (_remaining ~/ 60).toString().padLeft(2, '0');
    final s = (_remaining % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  double get _progress =>
      1 - (_remaining / widget.seconds);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceCard,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Rest',
              style: TextStyle(
                  color: AppColors.textHint,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2)),
          const SizedBox(height: 16),
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: _progress,
                    strokeWidth: 6,
                    backgroundColor:
                    AppColors.surfaceMuted,
                    valueColor:
                    const AlwaysStoppedAnimation<Color>(
                        AppColors.primary),
                  ),
                ),
                Text(
                  _label,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Rest between sets',
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13)),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Skip rest'),
          ),
        ),
      ],
    );
  }
}