import 'package:objectbox/objectbox.dart';


@Entity()
class UserGoals {
  int id = 0;

  @Unique()
  String uid = '';

  int    dailyStepGoal      = 10000;
  int    weeklyRunningKm    = 4;
  int    weeklyRunDays      = 3;
  int    dailyWaterMl       = 2500;
  int    dailyCalorieTarget = 2000;
  double targetWeightKg     = 70.0;
  double strideLengthM      = 0.75;
}




