import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../providers/analytics_provider.dart';
import '../providers/dashboard_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashAsync  = ref.watch(dashboardSummaryProvider);
    final heatAsync  = ref.watch(activityHeatmapProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header + Charts link
              Row(
                children: [
                  Expanded(
                    child: Text('Analytics',
                        style: Theme.of(context).textTheme.headlineLarge),
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.charts),
                    child: const Text('View charts →',
                        style: TextStyle(color: AppColors.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Streak Section ───────────────────
              Text('Current streak',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              dashAsync.when(
                loading: () => const SizedBox(
                    height: 80,
                    child: Center(child: CircularProgressIndicator())),
                error: (_, __) => const SizedBox.shrink(),
                data: (dash) => _StreakDisplay(days: dash.currentStreak),
              ),

              const SizedBox(height: 24),

              // ── Goal Progress Bars ───────────────
              Text('Goal progress',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              dashAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (dash) => _GoalProgressSection(summary: dash),
              ),

              const SizedBox(height: 24),

              // ── Activity Heatmap ─────────────────
              Text('Activity heatmap',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('Last 12 weeks of step activity',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              heatAsync.when(
                loading: () => const SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator())),
                error: (_, __) => const SizedBox.shrink(),
                data: (map) => _ActivityHeatmap(data: map),
              ),

              const SizedBox(height: 24),

              // ── Habit Calendar ───────────────────
              Text('Habit calendar',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              heatAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (map) => _HabitCalendar(activityMap: map),
              ),

              const SizedBox(height: 24),

              // ── Badges ───────────────────────────
              Text('Achievements',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              dashAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (dash) => _BadgesSection(summary: dash),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Streak Display ───────────────────────────
class _StreakDisplay extends StatelessWidget {
  final int days;
  const _StreakDisplay({required this.days});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF7043).withOpacity(0.2),
            const Color(0xFFFF7043).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFF7043).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 48)),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$days',
                style: const TextStyle(
                    fontSize: 52, fontWeight: FontWeight.bold,
                    color: Color(0xFFFF7043), height: 1),
              ),
              Text(
                days == 1 ? 'day streak' : 'days streak',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Best: $days days',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textHint)),
              const SizedBox(height: 4),
              Text(
                days > 0 ? 'Keep going!' : 'Start today!',
                style: const TextStyle(
                    fontSize: 13, color: Color(0xFFFF7043),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Goal Progress Bars ───────────────────────
class _GoalProgressSection extends StatelessWidget {
  final DashboardSummary summary;
  const _GoalProgressSection({required this.summary});

  @override
  Widget build(BuildContext context) {
    final goals = [
      _GoalItem(
        label: 'Steps',
        current: summary.todaySteps.toDouble(),
        goal: summary.stepGoal.toDouble(),
        unit: 'steps',
        color: AppColors.primary,
        icon: Icons.directions_walk_rounded,
      ),
      _GoalItem(
        label: 'Calories',
        current: summary.todayCalories,
        goal: summary.calorieGoal,
        unit: 'kcal',
        color: const Color(0xFFFF7043),
        icon: Icons.local_fire_department_rounded,
      ),
      _GoalItem(
        label: 'Water',
        current: summary.todayWaterMl.toDouble(),
        goal: summary.waterGoalMl.toDouble(),
        unit: 'ml',
        color: const Color(0xFF42A5F5),
        icon: Icons.water_drop_rounded,
      ),
      _GoalItem(
        label: 'Workouts/week',
        current: summary.workoutsThisWeek.toDouble(),
        goal: 5,
        unit: 'sessions',
        color: const Color(0xFFA78BFA),
        icon: Icons.fitness_center_rounded,
      ),
    ];

    return Column(
      children: goals.map((g) => _GoalProgressBar(item: g)).toList(),
    );
  }
}

class _GoalItem {
  final String label;
  final double current;
  final double goal;
  final String unit;
  final Color color;
  final IconData icon;
  const _GoalItem({
    required this.label, required this.current, required this.goal,
    required this.unit, required this.color, required this.icon,
  });
  double get progress => (current / goal).clamp(0.0, 1.0);
}

class _GoalProgressBar extends StatelessWidget {
  final _GoalItem item;
  const _GoalProgressBar({required this.item});

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
      child: Column(
        children: [
          Row(
            children: [
              Icon(item.icon, color: item.color, size: 16),
              const SizedBox(width: 8),
              Text(item.label,
                  style: Theme.of(context).textTheme.bodyMedium),
              const Spacer(),
              Text(
                '${item.current.toStringAsFixed(0)} / ${item.goal.toStringAsFixed(0)} ${item.unit}',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
              if (item.progress >= 1.0) ...[
                const SizedBox(width: 8),
                const Icon(Icons.check_circle_rounded,
                    color: AppColors.success, size: 16),
              ],
            ],
          ),
          const SizedBox(height: 10),
          // Animated progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: item.progress),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              builder: (_, value, __) => LinearProgressIndicator(
                value: value,
                minHeight: 10,
                backgroundColor: item.color.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation<Color>(item.color),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${(item.progress * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                  fontSize: 11, color: item.color,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Activity Heatmap ─────────────────────────
// GitHub contribution-style grid
class _ActivityHeatmap extends StatelessWidget {
  final Map<DateTime, int> data;
  const _ActivityHeatmap({required this.data});

  // Colors for 0–4 intensity levels
  static const _colors = [
    AppColors.surfaceMuted,           // 0 – no activity
    Color(0xFF166534),                // 1 – light
    Color(0xFF15803D),                // 2 – moderate
    Color(0xFF16A34A),                // 3 – active
    AppColors.primary,                // 4 – goal reached
  ];

  @override
  Widget build(BuildContext context) {
    // Build 12 weeks × 7 days grid
    final now = DateTime.now();
    final weeks = <List<DateTime>>[];
    DateTime cursor = now.subtract(const Duration(days: 83)); // ~12 weeks

    while (cursor.isBefore(now) || isSameDay(cursor, now)) {
      final week = <DateTime>[];
      for (int d = 0; d < 7; d++) {
        week.add(cursor);
        cursor = cursor.add(const Duration(days: 1));
      }
      weeks.add(week);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day labels
          Row(
            children: const [
              SizedBox(width: 4),
              Expanded(child: Text('M', style: TextStyle(
                  fontSize: 9, color: AppColors.textHint))),
              Expanded(child: Text('W', style: TextStyle(
                  fontSize: 9, color: AppColors.textHint))),
              Expanded(child: Text('F', style: TextStyle(
                  fontSize: 9, color: AppColors.textHint))),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: weeks.map((week) {
              return Expanded(
                child: Column(
                  children: week.map((day) {
                    final key = DateTime(day.year, day.month, day.day);
                    final intensity = data[key] ?? 0;
                    return Container(
                      margin: const EdgeInsets.all(1.5),
                      width: 12, height: 12,
                      decoration: BoxDecoration(
                        color: _colors[intensity.clamp(0, 4)],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          // Legend
          Row(
            children: [
              const Text('Less', style: TextStyle(
                  fontSize: 10, color: AppColors.textHint)),
              const SizedBox(width: 6),
              ..._colors.map((c) => Container(
                margin: const EdgeInsets.only(right: 3),
                width: 12, height: 12,
                decoration: BoxDecoration(
                  color: c,
                  borderRadius: BorderRadius.circular(2),
                ),
              )),
              const SizedBox(width: 3),
              const Text('More', style: TextStyle(
                  fontSize: 10, color: AppColors.textHint)),
            ],
          ),
        ],
      ),
    );
  }

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

// ─── Habit Calendar ───────────────────────────
class _HabitCalendar extends StatefulWidget {
  final Map<DateTime, int> activityMap;
  const _HabitCalendar({required this.activityMap});

  @override
  State<_HabitCalendar> createState() => _HabitCalendarState();
}

class _HabitCalendarState extends State<_HabitCalendar> {
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceMuted),
      ),
      child: TableCalendar(
        firstDay: DateTime.now().subtract(const Duration(days: 365)),
        lastDay: DateTime.now(),
        focusedDay: _focusedDay,
        onPageChanged: (day) => setState(() => _focusedDay = day),
        // Style
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          todayDecoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          defaultTextStyle: const TextStyle(color: AppColors.textPrimary),
          weekendTextStyle: const TextStyle(color: AppColors.textSecondary),
          outsideTextStyle: const TextStyle(color: AppColors.textHint),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleTextStyle: TextStyle(
              color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          leftChevronIcon: Icon(Icons.chevron_left_rounded,
              color: AppColors.textSecondary),
          rightChevronIcon: Icon(Icons.chevron_right_rounded,
              color: AppColors.textSecondary),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: AppColors.textHint, fontSize: 12),
          weekendStyle: TextStyle(color: AppColors.textHint, fontSize: 12),
        ),
        // Color each day based on activity intensity
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (ctx, day, focusedDay) {
            final key = DateTime(day.year, day.month, day.day);
            final intensity = widget.activityMap[key];
            if (intensity == null || intensity == 0) return null;

            final color = intensity >= 4
                ? AppColors.primary
                : intensity >= 2
                ? AppColors.primary.withOpacity(0.5)
                : AppColors.primary.withOpacity(0.25);

            return Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: color, shape: BoxShape.circle),
              child: Center(
                child: Text(
                  '${day.day}',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─── Badges / Achievements ────────────────────
class _BadgesSection extends StatelessWidget {
  final DashboardSummary summary;
  const _BadgesSection({required this.summary});

  @override
  Widget build(BuildContext context) {
    // Badge unlock logic based on real data
    final badges = [
      _Badge(
        emoji: '👟',
        title: 'First Steps',
        desc: 'Log your first day of steps',
        unlocked: summary.todaySteps > 0,
      ),
      _Badge(
        emoji: '🔥',
        title: '3-Day Streak',
        desc: 'Stay active 3 days in a row',
        unlocked: summary.currentStreak >= 3,
      ),
      _Badge(
        emoji: '💧',
        title: 'Hydrated',
        desc: 'Reach daily water goal',
        unlocked: summary.waterProgress >= 1.0,
      ),
      _Badge(
        emoji: '🏋️',
        title: 'Iron Will',
        desc: 'Complete 5 workouts in a week',
        unlocked: summary.workoutsThisWeek >= 5,
      ),
      _Badge(
        emoji: '🎯',
        title: 'Step Master',
        desc: 'Reach 10,000 steps in a day',
        unlocked: summary.stepProgress >= 1.0,
      ),
      _Badge(
        emoji: '🌙',
        title: 'Sleep Champion',
        desc: 'Get 8+ hours of sleep',
        unlocked: (summary.lastSleepHours ?? 0) >= 8,
      ),
    ];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: badges.map((b) => _BadgeCard(badge: b)).toList(),
    );
  }
}

class _Badge {
  final String emoji;
  final String title;
  final String desc;
  final bool unlocked;
  const _Badge({required this.emoji, required this.title,
    required this.desc, required this.unlocked});
}

class _BadgeCard extends StatelessWidget {
  final _Badge badge;
  const _BadgeCard({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: badge.unlocked
            ? AppColors.primary.withOpacity(0.1)
            : AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: badge.unlocked
              ? AppColors.primary.withOpacity(0.4)
              : AppColors.surfaceMuted,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ColorFiltered(
            // Greyscale filter for locked badges
            colorFilter: badge.unlocked
                ? const ColorFilter.mode(
                Colors.transparent, BlendMode.multiply)
                : const ColorFilter.matrix([
              0.2126, 0.7152, 0.0722, 0, 0,
              0.2126, 0.7152, 0.0722, 0, 0,
              0.2126, 0.7152, 0.0722, 0, 0,
              0,      0,      0,      1, 0,
            ]),
            child: Text(badge.emoji,
                style: const TextStyle(fontSize: 28)),
          ),
          const SizedBox(height: 6),
          Text(badge.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: badge.unlocked
                      ? AppColors.textPrimary
                      : AppColors.textHint)),
          if (!badge.unlocked) ...[
            const SizedBox(height: 2),
            const Icon(Icons.lock_rounded,
                size: 10, color: AppColors.textHint),
          ],
        ],
      ),
    );
  }
}




