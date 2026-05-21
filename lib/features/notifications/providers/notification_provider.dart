import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/services/notification_service.dart';

part 'notification_provider.g.dart';

// Holds the user's notification schedule settings
class NotificationSettings {
  final bool workoutReminder;
  final int  workoutHour;
  final int  workoutMinute;
  final bool waterReminder;
  final int  waterHour;
  final bool sleepReminder;
  final int  sleepHour;
  final bool mealReminder;

  const NotificationSettings({
    this.workoutReminder = true,
    this.workoutHour     = 8,
    this.workoutMinute   = 0,
    this.waterReminder   = true,
    this.waterHour       = 9,
    this.sleepReminder   = true,
    this.sleepHour       = 22,
    this.mealReminder    = false,
  });

  NotificationSettings copyWith({
    bool? workoutReminder,
    int?  workoutHour,
    int?  workoutMinute,
    bool? waterReminder,
    int?  waterHour,
    bool? sleepReminder,
    int?  sleepHour,
    bool? mealReminder,
  }) {
    return NotificationSettings(
      workoutReminder: workoutReminder ?? this.workoutReminder,
      workoutHour:     workoutHour     ?? this.workoutHour,
      workoutMinute:   workoutMinute   ?? this.workoutMinute,
      waterReminder:   waterReminder   ?? this.waterReminder,
      waterHour:       waterHour       ?? this.waterHour,
      sleepReminder:   sleepReminder   ?? this.sleepReminder,
      sleepHour:       sleepHour       ?? this.sleepHour,
      mealReminder:    mealReminder    ?? this.mealReminder,
    );
  }
}

@riverpod
class NotificationNotifier extends _$NotificationNotifier {
  @override
  NotificationSettings build() => const NotificationSettings();

  // Toggle + schedule/cancel a notification type
  Future<void> toggleWorkout(bool enabled) async {
    state = state.copyWith(workoutReminder: enabled);
    if (enabled) {
      await NotificationService.scheduleDailyAt(
        id:     NotificationIds.workout,
        title:  '💪 Workout time!',
        body:   'Your ${_planName()} session is ready. Let\'s go!',
        hour:   state.workoutHour,
        minute: state.workoutMinute,
      );
    } else {
      await NotificationService.cancel(NotificationIds.workout);
    }
  }

  Future<void> setWorkoutTime(int hour, int minute) async {
    state = state.copyWith(workoutHour: hour, workoutMinute: minute);
    if (state.workoutReminder) await toggleWorkout(true); // reschedule
  }

  Future<void> toggleWater(bool enabled) async {
    state = state.copyWith(waterReminder: enabled);
    if (enabled) {
      await NotificationService.scheduleDailyAt(
        id:    NotificationIds.water,
        title: '💧 Stay hydrated!',
        body:  'Time for a glass of water. You\'ve got this!',
        hour:  state.waterHour,
        minute: 0,
      );
    } else {
      await NotificationService.cancel(NotificationIds.water);
    }
  }

  Future<void> toggleSleep(bool enabled) async {
    state = state.copyWith(sleepReminder: enabled);
    if (enabled) {
      await NotificationService.scheduleDailyAt(
        id:     NotificationIds.sleep,
        title:  '🌙 Bedtime reminder',
        body:   'Wind down and get your 8 hours. Your body will thank you.',
        hour:   state.sleepHour,
        minute: 0,
      );
    } else {
      await NotificationService.cancel(NotificationIds.sleep);
    }
  }

  Future<void> toggleMeal(bool enabled) async {
    state = state.copyWith(mealReminder: enabled);
    if (enabled) {
      await NotificationService.scheduleDailyAt(
        id:     NotificationIds.meal,
        title:  '🥗 Log your meal',
        body:   'Don\'t forget to log what you\'ve eaten today.',
        hour:   12,
        minute: 0,
      );
    } else {
      await NotificationService.cancel(NotificationIds.meal);
    }
  }

  String _planName() => 'scheduled'; // Phase 6: reads active plan name
}