import 'package:objectbox/objectbox.dart';


@Entity()
class UserProfile {
  int id = 0;

  @Unique()
  String uid = '';

  late String   name;
  late String   email;
  late int      age;
  late double   weightKg;
  late double   heightCm;
  late String   fitnessGoal;
  late String   fitnessLevel;
  @Property(type: PropertyType.date)
  late DateTime createdAt;

  double get bmi {
    final h = heightCm / 100;
    return weightKg / (h * h);
  }

  String get bmiCategory {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25.0) return 'Normal weight';
    if (bmi < 30.0) return 'Overweight';
    return 'Obese';
  }
}




