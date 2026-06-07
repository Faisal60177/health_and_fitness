import 'package:isar/isar.dart';

part 'user_goals.g.dart';

@collection
class UserGoals {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String uid = '';

  int dailyStepGoal       = 10000;    // default 10,000 steps/day
  int weeklyRunningKm     = 4;        // weekly running distance target
  int weeklyRunDays       = 3;        // how many days/week to run
// Other goals
  int dailyWaterMl        = 2500;     // ml per day
  int dailyCalorieTarget  = 2000;     // kcal per day
  double targetWeightKg   = 70.0;     // target body weight

  // Stride length for distance calculation
  // Roughly height(cm) × 0.413 for walking
  double strideLengthM    = 0.75;
}