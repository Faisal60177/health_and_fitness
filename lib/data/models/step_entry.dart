import 'package:objectbox/objectbox.dart';


@Entity()
class StepEntry {
  int id = 0;

  @Index()
  String uid = '';

  @Property(type: PropertyType.date)
  late DateTime date;
  late int stepCount;
  late int dailyGoal;
  int slowSteps  = 0;
  int briskSteps = 0;
  double strideMeters = 0.75;

  double get distanceKm     => (stepCount * strideMeters) / 1000;
  double get caloriesBurned => stepCount * 0.04;
  double get progressPercent =>
      (stepCount / dailyGoal * 100).clamp(0.0, 100.0);
  bool   get goalReached    => stepCount >= dailyGoal;
  double get slowPercent    =>
      stepCount > 0 ? (slowSteps / stepCount).clamp(0.0, 1.0) : 0;
  double get briskPercent   =>
      stepCount > 0 ? (briskSteps / stepCount).clamp(0.0, 1.0) : 0;
}




