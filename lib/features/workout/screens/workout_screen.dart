import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/workout_log.dart';
import '../providers/workout_provider.dart';
import 'package:health_and_fitness/core/router/app_router.dart';
import 'package:go_router/go_router.dart';

class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the list of saved sessions
    final sessionsAsync = ref.watch(workoutNotifierProvider);
    // Watch the active in-progress workout
    final activeWorkout = ref.watch(activeWorkoutProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text('Workouts',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 4),
              Text('Track your training sessions',
                  style: Theme.of(context).textTheme.bodyMedium),

              const SizedBox(height: 24),

              // Active workout banner — shown when a session is in progress
              if (activeWorkout != null) ...[
                _ActiveWorkoutBanner(session: activeWorkout),
                const SizedBox(height: 16),
              ],

              // Start workout button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showStartWorkoutDialog(context, ref),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Start new workout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Quick links row to Phase 5 features
              Row(
                children: [
                  Expanded(
                    child: _QuickLink(
                      icon: Icons.list_alt_rounded,
                      label: 'Workout Plans',
                      color: const Color(0xFFA78BFA),
                      onTap: () => context.go(AppRoutes.plans),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickLink(
                      icon: Icons.search_rounded,
                      label: 'Exercise DB',
                      color: AppColors.primary,
                      onTap: () => context.go(AppRoutes.exercises),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text('Recent sessions',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 12),

              // Session history list
              Expanded(
                child: sessionsAsync.when(
                  loading: () =>
                  const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                  data: (sessions) => sessions.isEmpty
                      ? _EmptyState()
                      : ListView.builder(
                    itemCount: sessions.length,
                    itemBuilder: (ctx, i) =>
                        _SessionCard(session: sessions[i], ref: ref),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStartWorkoutDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                style: Theme.of(ctx).textTheme.headlineMedium),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              autofocus: true,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'e.g. Push Day, Leg Day...',
                hintStyle: const TextStyle(color: AppColors.textHint),
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
                  final name = nameController.text.trim();
                  if (name.isEmpty) return;
                  ref
                      .read(activeWorkoutProvider.notifier)
                      .start(name);
                  Navigator.pop(ctx);
                  // Navigate to active workout builder
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ActiveWorkoutScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
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

class _ActiveWorkoutBanner extends StatelessWidget {
  final WorkoutSession session;
  const _ActiveWorkoutBanner({required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.4)),
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
                        fontWeight: FontWeight.w600)),
                Text(
                  '${session.exercises.length} exercises · in progress',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const ActiveWorkoutScreen()),
            ),
            child: const Text(
              'Continue',
              style: TextStyle(
                  color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final WorkoutSession session;
  final WidgetRef ref;
  const _SessionCard({required this.session, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(session.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600)),
                ),
                Text(
                  _formatDate(session.date),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _Chip(
                    icon: Icons.fitness_center_rounded,
                    label: '${session.exercises.length} exercises'),
                const SizedBox(width: 8),
                _Chip(
                    icon: Icons.timer_rounded,
                    label: '${session.durationMinutes} min'),
                const SizedBox(width: 8),
                _Chip(
                    icon: Icons.bar_chart_rounded,
                    label:
                    '${session.totalVolume.toStringAsFixed(0)} kg total'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
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
  const _QuickLink({required this.icon, required this.label,
    required this.color, required this.onTap});

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
            Text(label, style: TextStyle(fontSize: 12, color: color,
                fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Active Workout Builder Screen
// ─────────────────────────────────────────────
class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  ConsumerState<ActiveWorkoutScreen> createState() =>
      _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  final _stopwatch = Stopwatch()..start();

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(activeWorkoutProvider);
    if (session == null) {
      Navigator.pop(context);
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(session.name,
            style: const TextStyle(color: AppColors.textPrimary)),
        actions: [
          // Finish button — saves session to Isar
          TextButton(
            onPressed: () => _finishWorkout(session),
            child: const Text('Finish',
                style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Add exercise button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showAddExerciseDialog(context),
                icon: const Icon(Icons.add_rounded, color: AppColors.primary),
                label: const Text('Add exercise',
                    style: TextStyle(color: AppColors.primary)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Exercise list
            Expanded(
              child: session.exercises.isEmpty
                  ? Center(
                child: Text('Add your first exercise',
                    style: Theme.of(context).textTheme.bodyMedium),
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

  void _showAddExerciseDialog(BuildContext context) {
    // Common exercise library — Phase 5 replaces with full DB
    final exercises = [
      ('Bench Press', 'Chest'),
      ('Squat', 'Legs'),
      ('Deadlift', 'Back'),
      ('Pull-up', 'Back'),
      ('Shoulder Press', 'Shoulders'),
      ('Bicep Curl', 'Arms'),
      ('Tricep Dip', 'Arms'),
      ('Plank', 'Core'),
      ('Running', 'Cardio'),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Choose exercise',
              style: Theme.of(ctx).textTheme.headlineMedium),
          const SizedBox(height: 16),
          ...exercises.map(
                (e) => ListTile(
              title: Text(e.$1,
                  style: const TextStyle(color: AppColors.textPrimary)),
              subtitle: Text(e.$2,
                  style: const TextStyle(color: AppColors.textSecondary)),
              onTap: () {
                ref
                    .read(activeWorkoutProvider.notifier)
                    .addExercise(e.$1, e.$2);
                Navigator.pop(ctx);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _finishWorkout(WorkoutSession session) async {
    // Set duration from stopwatch
    final finalSession = WorkoutSession()
      ..id = session.id
      ..name = session.name
      ..date = session.date
      ..durationMinutes = _stopwatch.elapsed.inMinutes
      ..exercises = session.exercises;

    await ref
        .read(workoutNotifierProvider.notifier)
        .addSession(finalSession);

    ref.read(activeWorkoutProvider.notifier).clear();

    if (mounted) Navigator.pop(context);
  }
}

// One exercise card with its set rows
class _ExerciseCard extends ConsumerWidget {
  final WorkoutExercise exercise;
  final int exerciseIndex;

  const _ExerciseCard({
    required this.exercise,
    required this.exerciseIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise name + muscle group
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exercise.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      Text(exercise.muscleGroup,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
                Text(
                  '${exercise.totalVolume.toStringAsFixed(0)} kg',
                  style: const TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Column headers
            const Row(
              children: [
                _SetHeader('Set'),
                _SetHeader('Weight (kg)'),
                _SetHeader('Reps'),
              ],
            ),

            // Set rows
            ...exercise.sets.asMap().entries.map(
                  (entry) => _SetRow(
                setNum: entry.key + 1,
                set: entry.value,
              ),
            ),

            const SizedBox(height: 8),

            // Add set button
            TextButton.icon(
              onPressed: () => _showAddSetDialog(context, ref),
              icon: const Icon(Icons.add_rounded,
                  size: 16, color: AppColors.primary),
              label: const Text('Add set',
                  style: TextStyle(color: AppColors.primary, fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSetDialog(BuildContext context, WidgetRef ref) {
    double weight = 20;
    int reps = 10;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: AppColors.surfaceCard,
          title: const Text('Add set',
              style: TextStyle(color: AppColors.textPrimary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Weight slider
              Text('Weight: ${weight.toStringAsFixed(1)} kg',
                  style: const TextStyle(color: AppColors.textSecondary)),
              Slider(
                value: weight,
                min: 0,
                max: 300,
                divisions: 600,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.surfaceMuted,
                onChanged: (v) => setState(() => weight = v),
              ),
              const SizedBox(height: 8),
              // Reps slider
              Text('Reps: $reps',
                  style: const TextStyle(color: AppColors.textSecondary)),
              Slider(
                value: reps.toDouble(),
                min: 1,
                max: 50,
                divisions: 49,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.surfaceMuted,
                onChanged: (v) => setState(() => reps = v.round()),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: AppColors.textHint)),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(activeWorkoutProvider.notifier).addSet(
                  exerciseIndex,
                  WorkoutSet.create(weightKg: weight, reps: reps),
                );
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
              ),
              child: const Text('Save set'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SetHeader extends StatelessWidget {
  final String text;
  const _SetHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(text,
          style: const TextStyle(
              fontSize: 11,
              color: AppColors.textHint,
              fontWeight: FontWeight.w500)),
    );
  }
}

class _SetRow extends StatelessWidget {
  final int setNum;
  final WorkoutSet set;
  const _SetRow({required this.setNum, required this.set});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text('$setNum',
                style: const TextStyle(color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text('${set.weightKg}',
                style: const TextStyle(color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text('${set.reps}',
                style: const TextStyle(color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
