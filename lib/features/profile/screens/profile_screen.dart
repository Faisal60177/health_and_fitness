import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/user_profile_repository.dart';
import 'package:health_and_fitness/features/sync/widgets/sync_card.dart';
import 'package:health_and_fitness/features/sync/providers/sync_provider.dart';

import '../../../data/repositories/weight_repository.dart';

part 'profile_screen.g.dart';

// ── Unified user data model ───────────────────────────────────
// Merges Firebase Auth + Firestore + Isar into one clean object
class UserData {
  final String name;
  final String email;
  final String? photoUrl;       // from Google sign-in
  final int    age;
  final double weightKg;
  final double heightCm;
  final String fitnessGoal;
  final String fitnessLevel;

  const UserData({
    required this.name,
    required this.email,
    this.photoUrl,
    required this.age,
    required this.weightKg,
    required this.heightCm,
    required this.fitnessGoal,
    required this.fitnessLevel,
  });

  double get bmi {
    final h = heightCm / 100;
    return weightKg / (h * h);
  }

  String get bmiCategory {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25.0) return 'Normal';
    if (bmi < 30.0) return 'Overweight';
    return 'Obese';
  }

  // Returns initials for avatar: "John Doe" → "JD"
  String get initials {
    if (name.trim().isEmpty) return '?';
    return name
        .trim()
        .split(' ')
        .where((w) => w.isNotEmpty)
        .map((w) => w[0].toUpperCase())
        .take(2)
        .join();
  }

  // Which sign-in method this user used
  String get provider {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'email';
    final providers = user.providerData.map((p) => p.providerId).toList();
    if (providers.contains('google.com')) return 'google';
    return 'email';
  }
}

// ── Provider: loads user data from all sources ────────────────
// ✅ Replace the userData provider with this safe version
@riverpod
Future<UserData> userData(UserDataRef ref) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) {
    return const UserData(
      name:         'Guest',
      email:        '',
      age:          25,
      weightKg:     70,
      heightCm:     170,
      fitnessGoal:  'maintain',
      fitnessLevel: 'beginner',
    );
  }

  final authName = currentUser.displayName ?? '';
  final authEmail = currentUser.email ?? '';
  final photoUrl  = currentUser.photoURL;

  Map<String, dynamic>? firestoreData;
  try {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    if (doc.exists) firestoreData = doc.data();
  } catch (_) {
    // Firestore unavailable — fall back to Isar
  }

  final isarProfile = await UserProfileRepository().getProfile();

  return UserData(
    name: authName.isNotEmpty
        ? authName
        : (firestoreData?['name'] as String? ?? 'User'),
    email:    authEmail,
    photoUrl: photoUrl,

    // ✅ FIX: Firestore stores numbers as int OR double
    // Using (num?) handles both safely
    age: (firestoreData?['age'] as num?)?.toInt()
        ?? isarProfile?.age
        ?? 25,

    weightKg: (firestoreData?['weightKg'] as num?)?.toDouble()
        ?? isarProfile?.weightKg
        ?? 70.0,

    heightCm: (firestoreData?['heightCm'] as num?)?.toDouble()
        ?? isarProfile?.heightCm
        ?? 170.0,

    fitnessGoal: firestoreData?['fitnessGoal'] as String?
        ?? isarProfile?.fitnessGoal
        ?? 'maintain',

    fitnessLevel: firestoreData?['fitnessLevel'] as String?
        ?? isarProfile?.fitnessLevel
        ?? 'beginner',
  );
}

// ── Profile Screen ────────────────────────────────────────────
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userDataProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: userAsync.when(
          loading: () =>
          const Center(child: CircularProgressIndicator()),
          error:   (e, _) =>
              Center(child: Text('Error loading profile: $e')),
          data:    (user) => _ProfileBody(user: user, ref: ref),
        ),
      ),
    );
  }
}

// ── Profile body ──────────────────────────────────────────────
class _ProfileBody extends StatelessWidget {
  final UserData user;
  final WidgetRef ref;

  const _ProfileBody({required this.user, required this.ref});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 12),

          // ── Avatar ──────────────────────────────────────────
          // Shows Google profile photo if available
          // Otherwise shows initials
          Stack(
            children: [
              Container(
                width: 90, height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.15),
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                clipBehavior: Clip.antiAlias,
                child: user.photoUrl != null && user.photoUrl!.isNotEmpty
                    ? Image.network(
                  user.photoUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      _InitialsAvatar(initials: user.initials),
                )
                    : _InitialsAvatar(initials: user.initials),
              ),
              // Provider badge (Google logo if signed in with Google)
              if (user.provider == 'google')
                Positioned(
                  bottom: 0, right: 0,
                  child: Container(
                    width: 26, height: 26,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.background, width: 2),
                    ),
                    child: const Icon(Icons.g_mobiledata_rounded,
                        size: 18, color: Colors.blue),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Real name from Firebase Auth ───────────────────
          Text(
            user.name,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 4),

          // Email
          Text(
            user.email,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 6),

          // Provider chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  user.provider == 'google'
                      ? Icons.g_mobiledata_rounded
                      : Icons.email_rounded,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  user.provider == 'google'
                      ? 'Signed in with Google'
                      : 'Signed in with Email',
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Stats row: weight · height · BMI ───────────────
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surfaceMuted),
            ),
            child: Row(
              children: [
                _StatCell(
                  value: '${user.weightKg.toStringAsFixed(1)}',
                  unit:  'kg',
                  label: 'Weight',
                ),
                _VertDivider(),
                _StatCell(
                  value: '${user.heightCm.toStringAsFixed(0)}',
                  unit:  'cm',
                  label: 'Height',
                ),
                _VertDivider(),
                _StatCell(
                  value: user.bmi.toStringAsFixed(1),
                  unit:  '',
                  label: user.bmiCategory,
                  valueColor: _bmiColor(user.bmi),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Goal + Level ────────────────────────────────────
          Row(
            children: [
              Expanded(child: _GoalCard(
                icon:  Icons.flag_rounded,
                label: 'Goal',
                value: _goalLabel(user.fitnessGoal),
                color: AppColors.primary,
              )),
              const SizedBox(width: 12),
              Expanded(child: _GoalCard(
                icon:  Icons.trending_up_rounded,
                label: 'Level',
                value: _capitalize(user.fitnessLevel),
                color: const Color(0xFFA78BFA),
              )),
            ],
          ),

          const SizedBox(height: 24),

          // ── Menu items ──────────────────────────────────────
          _MenuItem(
            icon:     Icons.person_outline_rounded,
            label:    'Edit profile',
            subtitle: 'Update your name, weight, height',
            onTap:    () => _showEditProfile(context, user),
          ),
          _MenuItem(
            icon:     Icons.notifications_rounded,
            label:    'Reminders',
            subtitle: 'Workout, water, sleep alerts',
            onTap:    () => context.go(AppRoutes.notifications),
          ),
          _MenuItem(
            icon:     Icons.self_improvement_rounded,
            label:    'Meditation & Breathing',
            subtitle: '4-7-8, Box breathing, and more',
            onTap:    () => context.go(AppRoutes.meditation),
          ),
          /*
          _MenuItem(
            icon:     Icons.psychology_rounded,
            label:    'AI Coach',
            subtitle: 'Chat with your personal trainer',
            onTap:    () => context.go(AppRoutes.aiCoach),
          ),


          _MenuItem(
            icon:     Icons.monitor_heart_rounded,
            label:    'Health Connect',
            subtitle: 'Sync wearables & Google Fit',
            onTap:    () => context.go(AppRoutes.healthConnect),
          ),

           */
          _MenuItem(
            icon:     Icons.emoji_events_rounded,
            label:    'Leaderboard',
            subtitle: 'Compete with friends',
            onTap:    () => context.go(AppRoutes.leaderboard),
          ),
          _MenuItem(
            icon:     Icons.flag_rounded,
            label:    'My Goals',
            subtitle: 'Steps, water, calories, weight targets',
            onTap:    () => context.go(AppRoutes.goalsSettings),
          ),
          _MenuItem(
            icon:     Icons.monitor_weight_rounded,
            label:    'Log weight',
            subtitle: 'Track your weight over time',
            onTap:    () => _showLogWeight(context),
          ),
          /*
          _MenuItem(
            icon:     Icons.workspace_premium_rounded,
            label:    'Go Premium',
            subtitle: 'Unlock all features',
            onTap:    () => context.go(AppRoutes.premium),
          ),

           */
          const SizedBox(height: 24),

          const SyncCard(),

          const SizedBox(height: 24),

          // ── Sign out ────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await AuthRepository().logout();
                if (context.mounted) context.go(AppRoutes.login);
              },
              icon:  const Icon(Icons.logout_rounded, size: 18),
              label: const Text('Sign out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.danger,
                side: const BorderSide(color: AppColors.danger),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // App version
          Text('Health & Fitness v1.0.0',
              style: Theme.of(context).textTheme.labelSmall),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Edit profile bottom sheet
  void _showEditProfile(BuildContext context, UserData user) {
    final nameCtrl   = TextEditingController(text: user.name);
    final weightCtrl = TextEditingController(
        text: user.weightKg.toStringAsFixed(1));
    final heightCtrl = TextEditingController(
        text: user.heightCm.toStringAsFixed(0));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceCard,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit profile',
                style: Theme.of(ctx).textTheme.headlineMedium),
            const SizedBox(height: 20),

            _EditField(ctrl: nameCtrl,   label: 'Name'),
            const SizedBox(height: 12),
            _EditField(ctrl: weightCtrl, label: 'Weight (kg)',
                isNumber: true),
            const SizedBox(height: 12),
            _EditField(ctrl: heightCtrl, label: 'Height (cm)',
                isNumber: true),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final uid = FirebaseAuth.instance.currentUser?.uid;
                  if (uid == null) return;

                  final newName   = nameCtrl.text.trim();
                  final newWeight = double.tryParse(weightCtrl.text) ?? user.weightKg;
                  final newHeight = double.tryParse(heightCtrl.text) ?? user.heightCm;

                  // Update Firebase Auth display name
                  await FirebaseAuth.instance.currentUser!
                      .updateDisplayName(newName);

                  // Update Firestore
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .update({
                    'name':      newName,
                    'weightKg':  newWeight,
                    'heightCm':  newHeight,
                    'updatedAt': FieldValue.serverTimestamp(),
                  });

                  // Update Isar (local cache)
                  final repo    = UserProfileRepository();
                  final profile = await repo.getProfile();
                  if (profile != null) {
                    profile.name     = newName;
                    profile.weightKg = newWeight;
                    profile.heightCm = newHeight;
                    await repo.saveProfile(profile);
                  }

                  // Refresh the profile screen
                  ref.invalidate(userDataProvider);

                  if (ctx.mounted) Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogWeight(BuildContext context) {
    final weightCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceCard,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Log weight',
                style: Theme.of(ctx).textTheme.headlineMedium),
            const SizedBox(height: 20),
            _EditField(ctrl: weightCtrl, label: 'Weight (kg)', isNumber: true),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final kg = double.tryParse(weightCtrl.text);
                  if (kg == null || kg <= 0) return;
                  await WeightRepository().logWeight(kg);
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Color _bmiColor(double bmi) {
    if (bmi < 18.5) return AppColors.warning;
    if (bmi < 25.0) return AppColors.success;
    if (bmi < 30.0) return AppColors.warning;
    return AppColors.danger;
  }

  String _goalLabel(String goal) {
    switch (goal) {
      case 'lose_weight': return 'Lose weight';
      case 'gain_muscle': return 'Build muscle';
      case 'maintain':    return 'Stay healthy';
      default:            return goal;
    }
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}

// ── Small widget helpers ──────────────────────────────────────

class _InitialsAvatar extends StatelessWidget {
  final String initials;
  const _InitialsAvatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String value;
  final String unit;
  final String label;
  final Color? valueColor;

  const _StatCell({
    required this.value,
    required this.unit,
    required this.label,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? AppColors.textPrimary)),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 2),
                Text(unit, style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary)),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(
              fontSize: 11, color: AppColors.textHint)),
        ],
      ),
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 40, color: AppColors.surfaceMuted);
}

class _GoalCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color  color;

  const _GoalCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(
              fontSize: 11, color: AppColors.textHint)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14)),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String   subtitle;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap:  onTap,
        shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: AppColors.surfaceCard,
        leading: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title:    Text(label,
            style: Theme.of(context).textTheme.bodyLarge),
        subtitle: Text(subtitle,
            style: Theme.of(context).textTheme.bodyMedium),
        trailing: const Icon(Icons.chevron_right_rounded,
            color: AppColors.textHint),
      ),
    );
  }
}




class _EditField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final bool   isNumber;

  const _EditField({
    required this.ctrl,
    required this.label,
    this.isNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(
            fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        TextField(
          controller:  ctrl,
          keyboardType: isNumber
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            filled:    true,
            fillColor: AppColors.surfaceMuted,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }
}
