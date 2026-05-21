import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/analytics_provider.dart';
import '../../../data/repositories/user_goals_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/user_goals.dart';


part 'charts_screen.g.dart';

@riverpod
Future<UserGoals> userGoals(UserGoalsRef ref) async {
  return UserGoalsRepository().getGoals();
}


class ChartsScreen extends ConsumerStatefulWidget {
  const ChartsScreen({super.key});

  @override
  ConsumerState<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends ConsumerState<ChartsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Tabs: Steps, Calories, Sleep, Weight
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final analyticsAsync = ref.watch(analyticsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Charts',
            style: TextStyle(color: AppColors.textPrimary)),
        actions: [
          // Week / Month toggle
          analyticsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (data) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _RangeToggle(
                currentRange: data.range,
                onChanged: (r) => ref
                    .read(analyticsNotifierProvider.notifier)
                    .setRange(r),
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textHint,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: 'Steps'),
            Tab(text: 'Calories'),
            Tab(text: 'Sleep'),
            Tab(text: 'Weight'),
          ],
        ),
      ),
      body: analyticsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) => TabBarView(
          controller: _tabController,
          children: [
            _StepsChart(data: data),
            _CaloriesChart(data: data),
            _SleepChart(data: data),
            _WeightChart(data: data),
          ],
        ),
      ),
    );
  }
}

class _RangeToggle extends StatelessWidget {
  final AnalyticsRange currentRange;
  final ValueChanged<AnalyticsRange> onChanged;
  const _RangeToggle({required this.currentRange, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: AnalyticsRange.values.map((r) {
          final isActive = r == currentRange;
          return GestureDetector(
            onTap: () => onChanged(r),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                r == AnalyticsRange.week ? '7D' : '30D',
                style: TextStyle(
                  fontSize: 12,
                  color: isActive ? Colors.black : AppColors.textHint,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Steps Bar Chart ─────────────────────────
class _StepsChart extends ConsumerWidget {
  final AnalyticsData data;
  const _StepsChart({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(userGoalsProvider);
    final stepGoal = goalsAsync.when(
      data:    (g) => g.dailyStepGoal.toDouble(),
      loading: () => 10000.0,
      error:   (_, __) => 10000.0,
    );

    if (data.stepHistory.isEmpty) return const _EmptyChart(label: 'No step data yet');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary row
          _ChartSummary(
            label: 'Daily average',
            value: '${data.avgSteps.toStringAsFixed(0)} steps',
            color: AppColors.primary,
          ),
          const SizedBox(height: 20),

          // Bar chart
          Container(
            height: 240,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surfaceMuted),
            ),
            child: BarChart(
              BarChartData(
                maxY: ([
                  data.stepHistory.map((e) => e.stepCount).reduce((a, b) => a > b ? a : b).toDouble(),
                  stepGoal,
                ].reduce((a, b) => a > b ? a : b) * 1.2),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (g, gi, rod, ri) => BarTooltipItem(
                      '${rod.toY.toStringAsFixed(0)} steps',
                      const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 44,
                    getTitlesWidget: (v, _) => Text(
                      v >= 1000 ? '${(v / 1000).toStringAsFixed(0)}k' : '${v.toInt()}',
                      style: const TextStyle(
                          color: AppColors.textHint, fontSize: 10),
                    ),
                  )),
                  rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (v, _) {
                      final i = v.toInt();
                      if (i < 0 || i >= data.stepHistory.length) {
                        return const SizedBox.shrink();
                      }
                      final d = data.stepHistory[i].date;
                      return Text('${d.day}/${d.month}',
                          style: const TextStyle(
                              color: AppColors.textHint, fontSize: 9));
                    },
                  )),
                ),
                gridData: FlGridData(
                  show: true,
                  // Dashed line at 10,000 steps goal
                  getDrawingHorizontalLine: (v) => FlLine(
                    color: v == stepGoal
                        ? AppColors.primary.withOpacity(0.5)
                        : AppColors.surfaceMuted.withOpacity(0.5),
                    strokeWidth: v == stepGoal ? 1.5 : 0.5,
                    dashArray: v == stepGoal ? [4, 4] : null,
                  ),
                  horizontalInterval: 2500,
                ),
                borderData: FlBorderData(show: false),
                barGroups: data.stepHistory.asMap().entries.map((e) {
                  final reached = e.value.stepCount >= stepGoal;
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value.stepCount.toDouble(),
                        // Green if goal reached, muted if not
                        color: reached
                            ? AppColors.primary
                            : AppColors.primary.withOpacity(0.4),
                        width: data.range == AnalyticsRange.week ? 24 : 10,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6)),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Calories Line Chart ──────────────────────
class _CaloriesChart extends ConsumerWidget  {
  final AnalyticsData data;
  const _CaloriesChart({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(userGoalsProvider);  // ← watch goals

    final calorieGoal = goalsAsync.when(
      data:    (g) => g.dailyCalorieTarget.toDouble(),
      loading: () => 2000.0,
      error:   (_, __) => 2000.0,
    );

    // Group food logs by day → daily calorie totals
    final byDay = <String, double>{};
    for (final f in data.foodHistory) {
      final key = '${f.date.year}-${f.date.month}-${f.date.day}';
      byDay[key] = (byDay[key] ?? 0) + f.calories;
    }

    if (byDay.isEmpty) return const _EmptyChart(label: 'No calorie data yet');

    final spots = byDay.values.toList().asMap().entries.map(
          (e) => FlSpot(e.key.toDouble(), e.value),
    ).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ChartSummary(
            label: 'Daily average',
            value: '${data.avgCalories.toStringAsFixed(0)} kcal',
            color: const Color(0xFFFF7043),
          ),
          const SizedBox(height: 20),
          Container(
            height: 240,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surfaceMuted),
            ),
            child: LineChart(
              LineChartData(
                minY: 0,
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (spots) => spots.map((s) =>
                        LineTooltipItem(
                          '${s.y.toStringAsFixed(0)} kcal',
                          const TextStyle(color: Colors.white, fontSize: 11),
                        ),
                    ).toList(),
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 44,
                    getTitlesWidget: (v, _) => Text(
                      '${v.toStringAsFixed(0)}',
                      style: const TextStyle(
                          color: AppColors.textHint, fontSize: 9),
                    ),
                    interval: 500,
                  )),
                  rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  // Goal line at 2000 kcal
                  getDrawingHorizontalLine: (v) => FlLine(
                    color: v == calorieGoal         // ← was v == 2000
                        ? const Color(0xFFFF7043).withOpacity(0.5)
                        : AppColors.surfaceMuted.withOpacity(0.4),
                    strokeWidth: v == calorieGoal ? 1.5 : 0.5,   // ← was 2000
                    dashArray:   v == calorieGoal ? [4, 4] : null, // ← was 2000
                  ),
                  horizontalInterval: 500,
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: const Color(0xFFFF7043),
                    barWidth: 3,
                    dotData: FlDotData(show: spots.length <= 10),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFFFF7043).withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sleep Chart (bar) ────────────────────────
class _SleepChart extends StatelessWidget {
  final AnalyticsData data;
  const _SleepChart({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.sleepHistory.isEmpty) {
      return const _EmptyChart(label: 'No sleep data yet');
    }

    final logs = data.sleepHistory.reversed.toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ChartSummary(
            label: 'Average sleep',
            value: '${data.avgSleep.toStringAsFixed(1)} hours',
            color: const Color(0xFF7C3AED),
          ),
          const SizedBox(height: 20),
          Container(
            height: 240,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surfaceMuted),
            ),
            child: BarChart(
              BarChartData(
                maxY: 12,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (g, gi, rod, ri) => BarTooltipItem(
                      '${rod.toY.toStringAsFixed(1)}h',
                      const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (v, _) => Text('${v.toInt()}h',
                        style: const TextStyle(
                            color: AppColors.textHint, fontSize: 10)),
                    interval: 2,
                  )),
                  rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 8,
                  getDrawingHorizontalLine: (v) => FlLine(
                    color: v == 8
                        ? const Color(0xFF7C3AED).withOpacity(0.5)
                        : AppColors.surfaceMuted.withOpacity(0.3),
                    strokeWidth: v == 8 ? 1.5 : 0.5,
                    dashArray: v == 8 ? [4, 4] : null,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: logs.asMap().entries.map((e) {
                  final h = e.value.durationHours;
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: h,
                        color: h >= 7
                            ? const Color(0xFF7C3AED)
                            : AppColors.warning,
                        width: 18,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(5)),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Weight Line Chart ────────────────────────
class _WeightChart extends StatelessWidget {
  final AnalyticsData data;
  const _WeightChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final logs = data.weightHistory.reversed.toList();
    if (logs.isEmpty) return const _EmptyChart(label: 'No weight data yet');

    final spots = logs.asMap().entries.map(
          (e) => FlSpot(e.key.toDouble(), e.value.weightKg),
    ).toList();

    final minY = logs.map((l) => l.weightKg).reduce((a, b) => a < b ? a : b) - 2;
    final maxY = logs.map((l) => l.weightKg).reduce((a, b) => a > b ? a : b) + 2;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _ChartSummary(
                label: 'Current',
                value: '${logs.last.weightKg.toStringAsFixed(1)} kg',
                color: const Color(0xFFA78BFA),
              ),
              const SizedBox(width: 16),
              if (logs.length >= 2)
                _ChartSummary(
                  label: 'Change',
                  value: '${(logs.last.weightKg - logs.first.weightKg).toStringAsFixed(1)} kg',
                  color: logs.last.weightKg <= logs.first.weightKg
                      ? AppColors.success
                      : AppColors.danger,
                ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 240,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surfaceMuted),
            ),
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (spots) => spots.map((s) =>
                        LineTooltipItem(
                          '${s.y.toStringAsFixed(1)} kg',
                          const TextStyle(color: Colors.white, fontSize: 11),
                        ),
                    ).toList(),
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 44,
                    getTitlesWidget: (v, _) => Text(
                      '${v.toStringAsFixed(1)}',
                      style: const TextStyle(
                          color: AppColors.textHint, fontSize: 9),
                    ),
                    interval: 1,
                  )),
                  rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: const Color(0xFFA78BFA),
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFFA78BFA).withOpacity(0.08),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartSummary extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _ChartSummary({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(
            fontSize: 12, color: AppColors.textHint)),
        Text(value, style: TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}

class _EmptyChart extends StatelessWidget {
  final String label;
  const _EmptyChart({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bar_chart_rounded,
              size: 56, color: AppColors.textHint),
          const SizedBox(height: 12),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}