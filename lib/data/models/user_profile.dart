import 'package:isar/isar.dart';
part 'user_profile.g.dart';

@collection
class UserProfile {
  Id id = Isar.autoIncrement;

  // THE KEY ADDITION — links this profile to a Firebase user
  // This is the Firebase uid returned by FirebaseAuth.instance.currentUser.uid
  // Index it for fast lookup — we query by uid constantly
  @Index(unique: true)  // unique: true means one profile per uid
  late String uid;

  late String name;
  late String email;
  late int age;
  late double weightKg;
  late double heightCm;
  late String fitnessGoal;
  late String fitnessLevel;
  late DateTime createdAt;

  double get bmi {
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  String get bmiCategory {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25.0) return 'Normal weight';
    if (bmi < 30.0) return 'Overweight';
    return 'Obese';
  }
}