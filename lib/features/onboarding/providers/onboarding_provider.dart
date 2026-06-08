import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_provider.g.dart';

// Holds all the data the user enters during onboarding
// Think of this as a temporary form state before saving to Isar
class OnboardingData {
  final int age;
  final double weightKg;
  final double heightCm;
  final String fitnessGoal;    // 'lose_weight', 'gain_muscle', 'maintain'
  final String fitnessLevel;   // 'beginner', 'intermediate', 'advanced'

  const OnboardingData({
    this.age = 25,
    this.weightKg = 70,
    this.heightCm = 170,
    this.fitnessGoal = 'maintain',
    this.fitnessLevel = 'beginner',
  });

  // copyWith allows updating one field without touching others
  // This is the immutable state update pattern
  OnboardingData copyWith({
    int? age,
    double? weightKg,
    double? heightCm,
    String? fitnessGoal,
    String? fitnessLevel,
  }) {
    return OnboardingData(
      age: age ?? this.age,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
    );
  }
}

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  OnboardingData build() => const OnboardingData();

  void setAge(int age) =>
      state = state.copyWith(age: age);

  void setWeight(double kg) =>
      state = state.copyWith(weightKg: kg);

  void setHeight(double cm) =>
      state = state.copyWith(heightCm: cm);

  void setGoal(String goal) =>
      state = state.copyWith(fitnessGoal: goal);

  void setLevel(String level) =>
      state = state.copyWith(fitnessLevel: level);
}



