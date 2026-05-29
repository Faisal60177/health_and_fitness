import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/workout/screens/workout_screen.dart';
import '../../features/nutrition/screens/nutrition_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/shell/screens/shell_screen.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../data/services/secure_storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/dashboard/screens/analytics_screen.dart';
import 'package:health_and_fitness/features/dashboard/screens/charts_screen.dart';
import 'package:health_and_fitness/features/dashboard/screens/export_screen.dart';
import '../../features/plans/screens/workout_plans_screen.dart';
import '../../features/meditation/screens/meditation_screen.dart';
import '../../features/notifications/screens/notification_settings_screen.dart';
import 'package:health_and_fitness/features/meals/screens/meal_plans_screen.dart';
import '../../features/ai_coach/screens/ai_coach_screen.dart';
import '../../features/wearable/screens/health_connect_screen.dart';
import '../../features/social/screens/leaderboard_screen.dart';
import '../../features/premium/screens/premium_screen.dart';
import 'package:health_and_fitness/data/repositories/user_profile_repository.dart';
import '../../features/steps/screens/step_screen.dart';
import '../../features/steps/screens/step_goal_screen.dart';
import 'package:health_and_fitness/features/settings/screens/goals_settings_screen.dart';
import 'package:health_and_fitness/features/sleep/screens/sleep_screen.dart';
import '../../features/exercises/screens/exercise_db_screen.dart';



part 'app_router.g.dart';

class AppRoutes {
  // Phase 1 routes — unchanged
  static const home      = '/home';
  static const workout   = '/workout';
  static const nutrition = '/nutrition';
  static const profile   = '/profile';
  static const analytics = '/analytics';
  static const charts    = '/charts';
  static const export    = '/export';
  static const exercises   = '/exercises';
  static const plans       = '/plans';
  static const meditation  = '/meditation';
  static const notifications = '/notifications';
  static const meals = '/meals';

  // Phase 2 routes — NEW
  static const login      = '/login';
  static const signup     = '/signup';
  static const onboarding = '/onboarding';

  static const aiCoach       = '/ai-coach';
  static const healthConnect = '/health-connect';
  static const leaderboard   = '/leaderboard';
  static const premium       = '/premium';

  static const steps     = '/steps';
  static const stepGoals = '/step-goals';
  static const goalsSettings = '/goals-settings';
}

// The router now needs 'ref' to read auth state
// So we make it a provider (not a plain final variable)
GoRouter createRouter(Ref ref) {

  // Notifier that triggers router to re-run redirect
  final authNotifier = ValueNotifier<bool>(false);

  // Every time auth state changes, toggle the notifier
  ref.listen(authStateProvider, (_, __) {
    authNotifier.value = !authNotifier.value;
  });

  return GoRouter(

    initialLocation: AppRoutes.login,
    refreshListenable: authNotifier,   // ADD THIS

    // redirect is called before EVERY navigation
    // Return a path to override where the user goes
    // Return null to allow the navigation as-is
    redirect: (context, state) async {
      final authState = ref.read(authStateProvider);
      final isLoggedIn = authState.valueOrNull != null;

      final currentPath = state.uri.toString();
      final isOnAuthPage = currentPath == AppRoutes.login ||
          currentPath == AppRoutes.signup;
      final isOnOnboarding = currentPath == AppRoutes.onboarding;

      // Case 1: Not logged in → send to login
      if (!isLoggedIn && !isOnAuthPage) return AppRoutes.login;

      // Case 2: Logged in but on auth page → check profile
      if (isLoggedIn && isOnAuthPage) {
        final profile = await UserProfileRepository().getProfile();
        if (profile != null) {
          // Profile exists (either from Isar or restored from Firestore)
          // Mark onboarding done and go home
          await SecureStorageService.setOnboardingDone();
          return AppRoutes.home;
        }
        return AppRoutes.onboarding;
      }

      // Case 3: Logged in, not on onboarding → verify profile exists
      if (isLoggedIn && !isOnOnboarding) {
        // Only check if storage says not done — avoids Isar hit on every nav
        final onboardingDone = await SecureStorageService.isOnboardingDone();
        if (!onboardingDone) {
          final profile = await UserProfileRepository().getProfile();
          if (profile != null) {
            // Isar has profile (restored from Firestore) — mark done, proceed
            await SecureStorageService.setOnboardingDone();
            return null;
          }
          return AppRoutes.onboarding;
        }
      }

      return null;
    },

    routes: [
      // Auth routes — no shell, no bottom nav
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Main app routes — wrapped in ShellRoute (bottom nav)
      ShellRoute(
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (c, s) => const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: AppRoutes.workout,
            pageBuilder: (c, s) =>
            const NoTransitionPage(child: WorkoutScreen()),
          ),
          GoRoute(
            path: AppRoutes.nutrition,
            pageBuilder: (c, s) =>
            const NoTransitionPage(child: NutritionScreen()),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (c, s) =>
            const NoTransitionPage(child: ProfileScreen()),
          ),
          GoRoute(
            path: AppRoutes.analytics,
            pageBuilder: (c, s) =>
            const NoTransitionPage(child: AnalyticsScreen()),
          ),
          GoRoute(
            path: AppRoutes.charts,
            builder: (c, s) => const ChartsScreen(),
          ),
          GoRoute(
            path: AppRoutes.export,
            builder: (c, s) => const ExportScreen(),
          ),
          GoRoute(
            path: AppRoutes.plans,
            builder: (c, s) => const WorkoutPlansScreen(),
          ),
          GoRoute(
            path: AppRoutes.meditation,
            builder: (c, s) => const MeditationScreen(),
          ),
          GoRoute(
            path: AppRoutes.notifications,
            builder: (c, s) => const NotificationSettingsScreen(),
          ),
          GoRoute(
            path: AppRoutes.meals,
            builder: (context, state) => const MealPlansScreen(),
          ),
          GoRoute(path: AppRoutes.aiCoach,
              builder: (c, s) => const AiCoachScreen()),
          GoRoute(path: AppRoutes.healthConnect,
              builder: (c, s) => const HealthConnectScreen()),
          GoRoute(path: AppRoutes.leaderboard,
              builder: (c, s) => const LeaderboardScreen()),
          GoRoute(path: AppRoutes.premium,
              builder: (c, s) => const PremiumScreen()),

          GoRoute(
            path: AppRoutes.steps,
            builder: (c, s) => const StepScreen(),
          ),
          GoRoute(
            path: AppRoutes.stepGoals,
            builder: (c, s) => const StepGoalScreen(),
          ),
          GoRoute(
            path: AppRoutes.goalsSettings,
            builder: (c, s) => const GoalsSettingsScreen(),
          ),
          GoRoute(
            path: '/sleep',
            builder: (c, s) => const SleepScreen(),
          ),
          GoRoute(
            path: AppRoutes.exercises,
            builder: (c, s) => const ExerciseDatabaseScreen(),
          ),

        ],
      ),
    ],
  );
}

// Provider that exposes the router — used in app.dart
@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return createRouter(ref);
}
