import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/user_goals.dart';
import '../../../data/repositories/user_goals_repository.dart';
import '../../home/providers/step_provider.dart';
import '../../water/providers/water_provider.dart';
import '../../nutrition/providers/calorie_provider.dart';

class GoalsSettingsScreen extends ConsumerStatefulWidget {
  const GoalsSettingsScreen({super.key});

  @override
  ConsumerState<GoalsSettingsScreen> createState() =>
      _GoalsSettingsScreenState();
}

class _GoalsSettingsScreenState
    extends ConsumerState<GoalsSettingsScreen> {
  late int    _stepGoal;
  late int    _waterGoal;
  late int    _calorieGoal;
  late double _weightTarget;
  late int    _weeklyRunKm;
  late int    _weeklyRunDays;
  bool _loaded = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserGoals>(
      future: UserGoalsRepository().getGoals(),
      builder: (ctx, snap) {
        if (!snap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final goals = snap.data!;
        if (!_loaded) {
          _stepGoal     = goals.dailyStepGoal;
          _waterGoal    = goals.dailyWaterMl;
          _calorieGoal  = goals.dailyCalorieTarget;
          _weightTarget = goals.targetWeightKg;
          _weeklyRunKm  = goals.weeklyRunningKm;
          _weeklyRunDays = goals.weeklyRunDays;
          _loaded       = true;
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: const Text('My Goals',
                style: TextStyle(color: AppColors.textPrimary)),
            actions: [
              TextButton(
                onPressed: _saveAll,
                child: const Text('Save',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [

              // Daily Steps
              _GoalTile(
                icon: Icons.directions_walk_rounded,
                color: const Color(0xFFFFB300),
                title: 'Daily step goal',
                currentValue: '$_stepGoal steps',
                child: Slider(
                  value: _stepGoal.toDouble(),
                  min:  1000, max: 20000, divisions: 190,
                  activeColor: const Color(0xFFFFB300),
                  inactiveColor: AppColors.surfaceMuted,
                  label: '$_stepGoal',
                  onChanged: (v) =>
                      setState(() => _stepGoal = v.round()),
                ),
              ),

              const SizedBox(height: 12),

              // Daily Water
              _GoalTile(
                icon: Icons.water_drop_rounded,
                color: const Color(0xFF42A5F5),
                title: 'Daily water goal',
                currentValue: '$_waterGoal ml',
                child: Slider(
                  value: _waterGoal.toDouble(),
                  min:  500, max: 5000, divisions: 90,
                  activeColor: const Color(0xFF42A5F5),
                  inactiveColor: AppColors.surfaceMuted,
                  label: '$_waterGoal ml',
                  onChanged: (v) =>
                      setState(() => _waterGoal = v.round()),
                ),
              ),

              const SizedBox(height: 12),

              // Daily Calories
              _GoalTile(
                icon: Icons.local_fire_department_rounded,
                color: const Color(0xFFFF7043),
                title: 'Daily calorie target',
                currentValue: '$_calorieGoal kcal',
                child: Slider(
                  value: _calorieGoal.toDouble(),
                  min:  1000, max: 4000, divisions: 60,
                  activeColor: const Color(0xFFFF7043),
                  inactiveColor: AppColors.surfaceMuted,
                  label: '$_calorieGoal kcal',
                  onChanged: (v) =>
                      setState(() => _calorieGoal = v.round()),
                ),
              ),

              const SizedBox(height: 12),

              // Target Weight
              _GoalTile(
                icon: Icons.monitor_weight_rounded,
                color: const Color(0xFFA78BFA),
                title: 'Target weight',
                currentValue:
                '${_weightTarget.toStringAsFixed(1)} kg',
                child: Slider(
                  value: _weightTarget,
                  min:  30, max: 200, divisions: 340,
                  activeColor: const Color(0xFFA78BFA),
                  inactiveColor: AppColors.surfaceMuted,
                  label: '${_weightTarget.toStringAsFixed(1)} kg',
                  onChanged: (v) =>
                      setState(() => _weightTarget = v),
                ),
              ),

              const SizedBox(height: 12),

              // Weekly Running
              _GoalTile(
                icon: Icons.directions_run_rounded,
                color: AppColors.primary,
                title: 'Weekly running target',
                currentValue: '$_weeklyRunKm km',
                child: Slider(
                  value: _weeklyRunKm.toDouble(),
                  min:  1, max: 100, divisions: 99,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.surfaceMuted,
                  label: '$_weeklyRunKm km',
                  onChanged: (v) =>
                      setState(() => _weeklyRunKm = v.round()),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveAll,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    padding:
                    const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Save all goals',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveAll() async {
    final repo  = UserGoalsRepository();
    final goals = await repo.getGoals();

    goals
      ..dailyStepGoal      = _stepGoal
      ..dailyWaterMl       = _waterGoal
      ..dailyCalorieTarget = _calorieGoal
      ..targetWeightKg     = _weightTarget
      ..weeklyRunningKm    = _weeklyRunKm
      ..weeklyRunDays      = _weeklyRunDays;

    await repo.saveGoals(goals);

    // Invalidate all providers so they reload with new goals
    ref.invalidate(stepProvider);
    ref.invalidate(waterProvider);
    ref.invalidate(calorieProvider);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All goals saved!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    }
  }
}

class _GoalTile extends StatelessWidget {
  final IconData icon;
  final Color    color;
  final String   title;
  final String   currentValue;
  final Widget   child;

  const _GoalTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.currentValue,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceMuted),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600)),
              ),
              Text(currentValue,
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
            ],
          ),
          child,
        ],
      ),
    );
  }
}



