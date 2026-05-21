import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/notification_service.dart';
import '../providers/notification_provider.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Reminders',
            style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Push Notifications',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 6),
          Text(
            'Get reminders to stay on track with your health goals.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),

          _NotificationTile(
            icon: Icons.fitness_center_rounded,
            iconColor: AppColors.primary,
            title: 'Workout reminder',
            subtitle: 'Daily at ${_fmt(settings.workoutHour, settings.workoutMinute)}',
            value: settings.workoutReminder,
            onChanged: (v) => ref
                .read(notificationNotifierProvider.notifier)
                .toggleWorkout(v),
            onTimeTap: settings.workoutReminder
                ? () => _pickTime(
              context,
              ref,
              initial: TimeOfDay(
                  hour: settings.workoutHour,
                  minute: settings.workoutMinute),
              onPicked: (t) => ref
                  .read(notificationNotifierProvider.notifier)
                  .setWorkoutTime(t.hour, t.minute),
            )
                : null,
          ),

          _NotificationTile(
            icon: Icons.water_drop_rounded,
            iconColor: const Color(0xFF42A5F5),
            title: 'Water reminder',
            subtitle: 'Daily at ${_fmt(settings.waterHour, 0)}',
            value: settings.waterReminder,
            onChanged: (v) => ref
                .read(notificationNotifierProvider.notifier)
                .toggleWater(v),
          ),

          _NotificationTile(
            icon: Icons.bedtime_rounded,
            iconColor: const Color(0xFF7C3AED),
            title: 'Sleep reminder',
            subtitle: 'Daily at ${_fmt(settings.sleepHour, 0)}',
            value: settings.sleepReminder,
            onChanged: (v) => ref
                .read(notificationNotifierProvider.notifier)
                .toggleSleep(v),
          ),

          _NotificationTile(
            icon: Icons.restaurant_rounded,
            iconColor: const Color(0xFFFF7043),
            title: 'Meal log reminder',
            subtitle: 'Daily at 12:00 PM',
            value: settings.mealReminder,
            onChanged: (v) => ref
                .read(notificationNotifierProvider.notifier)
                .toggleMeal(v),
          ),

          const SizedBox(height: 24),

          // Test notification button
          OutlinedButton.icon(
            onPressed: () async {
              final granted =
              await NotificationService.requestPermission();
              if (!granted) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Enable notifications in device settings'),
                    ),
                  );
                }
                return;
              }
              await NotificationService.showInstant(
                id:    99,
                title: '🎉 Notifications are working!',
                body:  'You\'ll now receive your health reminders.',
              );
            },
            icon: const Icon(Icons.notifications_rounded,
                color: AppColors.primary),
            label: const Text('Send test notification',
                style: TextStyle(color: AppColors.primary)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(int hour, int minute) {
    final period = hour < 12 ? 'AM' : 'PM';
    final h = hour == 0 ? 12 : hour > 12 ? hour - 12 : hour;
    return '$h:${minute.toString().padLeft(2, '0')} $period';
  }

  Future<void> _pickTime(
      BuildContext context,
      WidgetRef ref, {
        required TimeOfDay initial,
        required ValueChanged<TimeOfDay> onPicked,
      }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
              primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) onPicked(picked);
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onTimeTap;

  const _NotificationTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.onTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceMuted),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context).textTheme.bodyLarge),
                GestureDetector(
                  onTap: onTimeTap,
                  child: Row(
                    children: [
                      Text(subtitle,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium),
                      if (onTimeTap != null) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.edit_rounded,
                            size: 12, color: AppColors.primary),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}