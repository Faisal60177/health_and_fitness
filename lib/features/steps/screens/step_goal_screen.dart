import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/user_goals.dart';
import '../../../data/repositories/user_goals_repository.dart';
import '../../home/providers/step_provider.dart';

part 'step_goal_screen.g.dart';

@riverpod
Future<UserGoals> userGoals(UserGoalsRef ref) async {
  return UserGoalsRepository().getGoals();
}

class StepGoalScreen extends ConsumerStatefulWidget {
  const StepGoalScreen({super.key});

  @override
  ConsumerState<StepGoalScreen> createState() => _StepGoalScreenState();
}

class _StepGoalScreenState extends ConsumerState<StepGoalScreen> {
  late int    _dailyStepGoal;
  late int    _weeklyRunKm;
  late int    _weeklyRunDays;
  bool        _loaded = false;

  // Common preset step goals shown as quick-select chips
  static const _presets = [3000, 5000, 6500, 8000, 10000, 12000, 15000];

  @override
  Widget build(BuildContext context) {
    final goalsAsync = ref.watch(userGoalsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('My Goal',
            style: TextStyle(color: AppColors.textPrimary)),
        actions: [
          TextButton(
            onPressed: _loaded ? _saveGoals : null,
            child: const Text('Save',
                style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: goalsAsync.when(
        loading: () =>
        const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (goals) {
          // Initialize state once from loaded goals
          if (!_loaded) {
            _dailyStepGoal = goals.dailyStepGoal;
            _weeklyRunKm   = goals.weeklyRunningKm;
            _weeklyRunDays = goals.weeklyRunDays;
            _loaded        = true;
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [

              // ── Daily Walking Target (Image 2) ──────────────
              _GoalSection(
                title: 'Daily walking target',
                subtitle:
                '$_dailyStepGoal steps',
                child: Column(
                  children: [
                    // Preset chips row
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _presets.map((preset) {
                        final isSelected =
                            _dailyStepGoal == preset;
                        return GestureDetector(
                          onTap: () => setState(
                                  () => _dailyStepGoal = preset),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFFFB300)
                                  : AppColors.surfaceMuted,
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                            child: Text(
                              _formatSteps(preset),
                              style: TextStyle(
                                fontSize: 13,
                                color: isSelected
                                    ? Colors.black
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // Slider for fine-tuning
                    Row(
                      children: [
                        const Text('1,000',
                            style: TextStyle(
                                color: AppColors.textHint,
                                fontSize: 11)),
                        Expanded(
                          child: Slider(
                            value: _dailyStepGoal.toDouble(),
                            min:  1000,
                            max:  20000,
                            divisions: 190,
                            activeColor: const Color(0xFFFFB300),
                            inactiveColor: AppColors.surfaceMuted,
                            label: _formatSteps(_dailyStepGoal),
                            onChanged: (v) => setState(
                                    () => _dailyStepGoal = v.round()),
                          ),
                        ),
                        const Text('20,000',
                            style: TextStyle(
                                color: AppColors.textHint,
                                fontSize: 11)),
                      ],
                    ),

                    // Big number display
                    Text(
                      _formatSteps(_dailyStepGoal),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFB300),
                      ),
                    ),
                    const Text('steps per day',
                        style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13)),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Weekly Running Target (Image 2) ─────────────
              _GoalSection(
                title: 'Weekly running target',
                subtitle: '$_weeklyRunKm km',
                child: Column(
                  children: [
                    Slider(
                      value: _weeklyRunKm.toDouble(),
                      min:   1,
                      max:   50,
                      divisions: 49,
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.surfaceMuted,
                      label: '$_weeklyRunKm km',
                      onChanged: (v) =>
                          setState(() => _weeklyRunKm = v.round()),
                    ),
                    Text(
                      '$_weeklyRunKm km',
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary),
                    ),
                    const Text('per week',
                        style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13)),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Weekly Number of Runs (Image 2) ─────────────
              _GoalSection(
                title: 'Weekly number of runs',
                subtitle: '$_weeklyRunDays day(s)',
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(7, (i) {
                        final day     = i + 1;
                        final selected = day <= _weeklyRunDays;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _weeklyRunDays = day),
                          child: Container(
                            width: 38, height: 38,
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.surfaceMuted,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$day',
                                style: TextStyle(
                                  color: selected
                                      ? Colors.black
                                      : AppColors.textHint,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$_weeklyRunDays day(s) per week',
                      style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveGoals,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB300),
                    foregroundColor: Colors.black,
                    padding:
                    const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Save goals',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _saveGoals() async {
    final repo  = UserGoalsRepository();
    final goals = await repo.getGoals();

    goals
      ..dailyStepGoal   = _dailyStepGoal
      ..weeklyRunningKm = _weeklyRunKm
      ..weeklyRunDays   = _weeklyRunDays;

    await repo.saveGoals(goals);

    // Update the live step provider with the new goal immediately
    ref.read(stepNotifierProvider.notifier).updateDailyGoal(
        _dailyStepGoal);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Goals saved successfully'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    }
  }

  String _formatSteps(int steps) {
    if (steps >= 1000) {
      return '${(steps / 1000).toStringAsFixed(steps % 1000 == 0 ? 0 : 1)}k';
    }
    return '$steps';
  }
}

class _GoalSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _GoalSection({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
              ),
              Text(subtitle,
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13)),
            ],
          ),
          const Divider(color: AppColors.surfaceMuted, height: 20),
          child,
        ],
      ),
    );
  }
}