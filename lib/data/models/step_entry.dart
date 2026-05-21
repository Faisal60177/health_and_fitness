import 'package:isar/isar.dart';

part 'step_entry.g.dart';

@collection
class StepEntry {
  Id id = Isar.autoIncrement;

  @Index()
  late String uid;

  late DateTime date;
  late int stepCount;
  late int dailyGoal;         // now editable per user

  // Walking pace breakdown — store slow vs brisk split
  int slowSteps  = 0;         // steps under 100 steps/min
  int briskSteps = 0;         // steps at 100+ steps/min (Image 1 shows this split)

  // Distance and calories — computed from steps
  // Average stride length ~0.75m, varies by height
  double strideMeters = 0.75;

  double get distanceKm => (stepCount * strideMeters) / 1000;
  double get caloriesBurned => stepCount * 0.04;
  double get progressPercent =>
      (stepCount / dailyGoal * 100).clamp(0.0, 100.0);
  bool get goalReached => stepCount >= dailyGoal;

  // Pace percentages for the slow/brisk bar (Image 1)
  double get slowPercent =>
      stepCount > 0 ? (slowSteps / stepCount).clamp(0.0, 1.0) : 0;
  double get briskPercent =>
      stepCount > 0 ? (briskSteps / stepCount).clamp(0.0, 1.0) : 0;
}