import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../providers/onboarding_provider.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/repositories/user_profile_repository.dart';
import '../../../data/services/secure_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  // PageController drives the multi-step slides
  final _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;
  bool _isSaving = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }


  // Called when user taps Finish on the last page
  Future<void> _completeOnboarding() async {
    // ✅ Show loading so user can't double-tap
    setState(() => _isSaving = true);

    try {
      final data        = ref.read(onboardingProvider);
      final currentUser = FirebaseAuth.instance.currentUser;

      final realName  = currentUser?.displayName ?? '';
      final realEmail = currentUser?.email        ?? '';

      // Build UserProfile for local Isar storage
      final profile = UserProfile()
        ..name         = realName.isNotEmpty ? realName : 'User'
        ..email        = realEmail
        ..age          = data.age
        ..weightKg     = data.weightKg
        ..heightCm     = data.heightCm
        ..fitnessGoal  = data.fitnessGoal
        ..fitnessLevel = data.fitnessLevel
        ..createdAt    = DateTime.now();

      // ✅ Save to Isar (local — works offline)
      await UserProfileRepository().saveProfile(profile);

      // ✅ Save to Firestore (cloud — syncs across devices)
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .set({
          'uid':         currentUser.uid,           // ✅ store uid for queries
          'name':        realName.isNotEmpty ? realName : 'User',
          'email':       realEmail,
          'age':         data.age,                  // stored as int
          'weightKg':    data.weightKg,             // stored as double
          'heightCm':    data.heightCm,             // stored as double
          'fitnessGoal': data.fitnessGoal,
          'fitnessLevel': data.fitnessLevel,
          'bmi':         profile.bmi,
          'onboardingDone': true,                   // ✅ useful flag for future checks
          'createdAt':   FieldValue.serverTimestamp(),
          'updatedAt':   FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));               // merge = don't overwrite other fields
      }

      // ✅ Mark onboarding done in secure storage
      await SecureStorageService.setOnboardingDone();

      if (mounted) context.go(AppRoutes.home);

    } catch (e) {
      // ✅ Show error instead of silently failing
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save profile: ${e.toString()}'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(onboardingProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator at top
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (_currentPage > 0)
                        GestureDetector(
                          onTap: _prevPage,
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: AppColors.textSecondary,
                          ),
                        )
                      else
                        const SizedBox(width: 24),
                      const SizedBox(width: 12),
                      // Progress dots
                      Expanded(
                        child: Row(
                          children: List.generate(_totalPages, (i) {
                            return Expanded(
                              child: Container(
                                height: 4,
                                margin: const EdgeInsets.only(right: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: i <= _currentPage
                                      ? AppColors.primary
                                      : AppColors.surfaceMuted,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${_currentPage + 1}/$_totalPages',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // PageView — the 4 onboarding steps
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // buttons only
                onPageChanged: (page) =>
                    setState(() => _currentPage = page),
                children: [
                  _AgeStep(
                    age: data.age,
                    onChanged: (v) =>
                        ref.read(onboardingProvider.notifier).setAge(v),
                  ),
                  _BodyStep(
                    weightKg: data.weightKg,
                    heightCm: data.heightCm,
                    onWeightChanged: (v) => ref
                        .read(onboardingProvider.notifier)
                        .setWeight(v),
                    onHeightChanged: (v) => ref
                        .read(onboardingProvider.notifier)
                        .setHeight(v),
                  ),
                  _GoalStep(
                    selected: data.fitnessGoal,
                    onSelected: (v) => ref
                        .read(onboardingProvider.notifier)
                        .setGoal(v),
                  ),
                  _LevelStep(
                    selected: data.fitnessLevel,
                    onSelected: (v) => ref
                        .read(onboardingProvider.notifier)
                        .setLevel(v),
                  ),
                ],
              ),
            ),

            // Next / Finish button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: // Update the Continue/Finish button in build()
                ElevatedButton(
                  // ✅ Disable while saving to Firestore
                  onPressed: _isSaving ? null : _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.black))
                      : Text(
                    _currentPage == _totalPages - 1
                        ? 'Start my journey'
                        : 'Continue',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Individual step pages ---

class _AgeStep extends StatelessWidget {
  final int age;
  final ValueChanged<int> onChanged;

  const _AgeStep({required this.age, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('How old are you?',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('We use this to personalise your plan.',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 60),
          Center(
            child: Text(
              '$age',
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const Center(
            child: Text(
              'years',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 18),
            ),
          ),
          const SizedBox(height: 40),
          // Slider from age 10 to 90
          Slider(
            value: age.toDouble(),
            min: 10,
            max: 90,
            divisions: 80,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.surfaceMuted,
            onChanged: (v) => onChanged(v.round()),
          ),
        ],
      ),
    );
  }
}

class _BodyStep extends StatelessWidget {
  final double weightKg;
  final double heightCm;
  final ValueChanged<double> onWeightChanged;
  final ValueChanged<double> onHeightChanged;

  const _BodyStep({
    required this.weightKg,
    required this.heightCm,
    required this.onWeightChanged,
    required this.onHeightChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your body measurements',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('Used to calculate your BMI and calorie targets.',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 40),

          // Weight slider
          _SliderRow(
            label: 'Weight',
            value: weightKg,
            unit: 'kg',
            min: 30,
            max: 200,
            onChanged: onWeightChanged,
          ),
          const SizedBox(height: 32),

          // Height slider
          _SliderRow(
            label: 'Height',
            value: heightCm,
            unit: 'cm',
            min: 100,
            max: 250,
            onChanged: onHeightChanged,
          ),

          const SizedBox(height: 40),

          // Live BMI preview
          _BmiPreview(weightKg: weightKg, heightCm: heightCm),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String label;
  final double value;
  final String unit;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const _SliderRow({
    required this.label,
    required this.value,
    required this.unit,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyLarge),
            const Spacer(),
            Text(
              '${value.toStringAsFixed(1)} $unit',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.surfaceMuted,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _BmiPreview extends StatelessWidget {
  final double weightKg;
  final double heightCm;

  const _BmiPreview({required this.weightKg, required this.heightCm});

  @override
  Widget build(BuildContext context) {
    final heightM = heightCm / 100;
    final bmi = weightKg / (heightM * heightM);

    String category;
    Color color;
    if (bmi < 18.5) {
      category = 'Underweight';
      color = AppColors.warning;
    } else if (bmi < 25) {
      category = 'Normal weight';
      color = AppColors.success;
    } else if (bmi < 30) {
      category = 'Overweight';
      color = AppColors.warning;
    } else {
      category = 'Obese';
      color = AppColors.danger;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your BMI',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              Text(
                bmi.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Container(width: 1, height: 40, color: color.withOpacity(0.3)),
          const SizedBox(width: 16),
          Text(category, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _GoalStep extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const _GoalStep({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final goals = [
      ('lose_weight', 'Lose weight', 'Burn fat, improve cardiovascular health'),
      ('gain_muscle', 'Build muscle', 'Increase strength and muscle mass'),
      ('maintain',    'Stay healthy', 'Maintain weight, improve overall fitness'),
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('What is your goal?',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('This shapes your daily targets and recommendations.',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 32),
          ...goals.map((g) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SelectableCard(
              title: g.$2,
              subtitle: g.$3,
              isSelected: selected == g.$1,
              onTap: () => onSelected(g.$1),
            ),
          )),
        ],
      ),
    );
  }
}

class _LevelStep extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const _LevelStep({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final levels = [
      ('beginner',     'Beginner',     'New to fitness, just starting out'),
      ('intermediate', 'Intermediate', 'Working out 2–3 times per week'),
      ('advanced',     'Advanced',     'Training 4+ times per week'),
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Fitness level',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('Be honest — we match your plan to your current level.',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 32),
          ...levels.map((l) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SelectableCard(
              title: l.$2,
              subtitle: l.$3,
              isSelected: selected == l.$1,
              onTap: () => onSelected(l.$1),
            ),
          )),
        ],
      ),
    );
  }
}

class _SelectableCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectableCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.surfaceMuted,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.primary, size: 22),
          ],
        ),
      ),
    );
  }
}



