import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/sleep_log.dart';
import '../providers/sleep_provider.dart';

class SleepScreen extends ConsumerWidget {
  const SleepScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sleepAsync = ref.watch(sleepProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: sleepAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (logs) => SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sleep', style: Theme.of(context).textTheme.headlineLarge),
                Text('Track your rest quality',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 24),

                // Summary cards
                _SleepSummaryRow(logs: logs),
                const SizedBox(height: 20),

                // Weekly duration bar chart
                if (logs.isNotEmpty) ...[
                  Text('Last 7 nights',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  _SleepBarChart(logs: logs.take(7).toList().reversed.toList()),
                  const SizedBox(height: 24),
                ],

                // Log sleep button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showLogSleepSheet(context, ref),
                    icon: const Icon(Icons.bedtime_rounded),
                    label: const Text('Log last night'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // History list
                Text('History',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                ...logs.map((log) => _SleepLogCard(log: log, ref: ref)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogSleepSheet(BuildContext context, WidgetRef ref) {
    // Default: slept 11pm, woke 7am
    DateTime bedTime = DateTime(
      DateTime.now().year, DateTime.now().month,
      DateTime.now().day - 1, 23, 0,
    );
    DateTime wakeTime = DateTime(
      DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 7, 0,
    );
    int quality = 4;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceCard,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.fromLTRB(
              24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Log sleep', style: Theme.of(ctx).textTheme.headlineMedium),
              const SizedBox(height: 20),

              // Duration preview
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      _calcDuration(bedTime, wakeTime),
                      style: const TextStyle(
                          fontSize: 40, fontWeight: FontWeight.bold,
                          color: Color(0xFF7C3AED)),
                    ),
                    Text('hours of sleep',
                        style: Theme.of(ctx).textTheme.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Bed time picker
              _TimeRow(
                label: 'Bed time',
                time: bedTime,
                onTap: () async {
                  final t = await showTimePicker(
                    context: ctx,
                    initialTime: TimeOfDay.fromDateTime(bedTime),
                  );
                  if (t != null) setState(() => bedTime = DateTime(
                      bedTime.year, bedTime.month, bedTime.day,
                      t.hour, t.minute));
                },
              ),
              const SizedBox(height: 8),

              // Wake time picker
              _TimeRow(
                label: 'Wake time',
                time: wakeTime,
                onTap: () async {
                  final t = await showTimePicker(
                    context: ctx,
                    initialTime: TimeOfDay.fromDateTime(wakeTime),
                  );
                  if (t != null) setState(() => wakeTime = DateTime(
                      wakeTime.year, wakeTime.month, wakeTime.day,
                      t.hour, t.minute));
                },
              ),
              const SizedBox(height: 16),

              // Quality stars
              Text('Sleep quality',
                  style: Theme.of(ctx).textTheme.bodyMedium),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) => GestureDetector(
                  onTap: () => setState(() => quality = i + 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      Icons.star_rounded,
                      size: 36,
                      color: i < quality
                          ? const Color(0xFFFFD700)
                          : AppColors.surfaceMuted,
                    ),
                  ),
                )),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(sleepProvider.notifier).logSleep(
                      bedTime: bedTime,
                      wakeTime: wakeTime,
                      quality: quality,
                    );
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save sleep'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _calcDuration(DateTime bed, DateTime wake) {
    final diff = wake.difference(bed);
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    return '$h:${m.toString().padLeft(2, '0')}';
  }
}

class _TimeRow extends StatelessWidget {
  final String label;
  final DateTime time;
  final VoidCallback onTap;
  const _TimeRow({required this.label, required this.time, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            Text(
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.access_time_rounded,
                color: AppColors.textHint, size: 16),
          ],
        ),
      ),
    );
  }
}

class _SleepSummaryRow extends StatelessWidget {
  final List<SleepLog> logs;
  const _SleepSummaryRow({required this.logs});

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) return const SizedBox.shrink();

    final avg = logs.isEmpty ? 0.0
        : logs.fold(0.0, (s, l) => s + l.durationHours) / logs.length;
    final last = logs.first;

    return Row(
      children: [
        Expanded(child: _SummaryCell(
          label: 'Last night',
          value: last.durationFormatted,
          color: const Color(0xFF7C3AED),
        )),
        const SizedBox(width: 12),
        Expanded(child: _SummaryCell(
          label: '7-day avg',
          value: '${avg.toStringAsFixed(1)}h',
          color: AppColors.primary,
        )),
        const SizedBox(width: 12),
        Expanded(child: _SummaryCell(
          label: 'Quality',
          value: last.qualityLabel,
          color: const Color(0xFFFFD700),
        )),
      ],
    );
  }
}

class _SummaryCell extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _SummaryCell({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(
              fontSize: 11, color: AppColors.textHint)),
        ],
      ),
    );
  }
}

class _SleepBarChart extends StatelessWidget {
  final List<SleepLog> logs;
  const _SleepBarChart({required this.logs});

  @override
  Widget build(BuildContext context) {
    // Ideal sleep = 8 hours — shown as dotted reference line
    const idealHours = 8.0;

    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceMuted),
      ),
      child: BarChart(
        BarChartData(
          maxY: 10,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final log = logs[group.x];
                return BarTooltipItem(
                  log.durationFormatted,
                  const TextStyle(color: Colors.white, fontSize: 12),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, meta) {
                  final days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
                  final idx = val.toInt();
                  if (idx < 0 || idx >= logs.length) return const SizedBox.shrink();
                  final d = logs[idx].date;
                  return Text(
                    days[d.weekday - 1],
                    style: const TextStyle(
                        color: AppColors.textHint, fontSize: 10),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            horizontalInterval: idealHours,
            getDrawingHorizontalLine: (val) => FlLine(
              color: val == idealHours
                  ? AppColors.primary.withOpacity(0.5)
                  : AppColors.surfaceMuted,
              strokeWidth: val == idealHours ? 1.5 : 0.5,
              dashArray: val == idealHours ? [4, 4] : null,
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: logs.asMap().entries.map((entry) {
            final hours = entry.value.durationHours;
            final color = hours >= 7
                ? const Color(0xFF7C3AED)
                : hours >= 5
                ? AppColors.warning
                : AppColors.danger;
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: hours,
                  color: color,
                  width: 20,
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6)),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SleepLogCard extends StatelessWidget {
  final SleepLog log;
  final WidgetRef ref;
  const _SleepLogCard({required this.log, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(log.id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (_) =>
          ref.read(sleepProvider.notifier).deleteLog(log.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.danger.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_rounded, color: AppColors.danger),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceMuted),
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED).withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.bedtime_rounded,
                  color: Color(0xFF7C3AED), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${log.date.day}/${log.date.month}/${log.date.year}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(log.durationFormatted,
                      style: const TextStyle(
                          color: Color(0xFF7C3AED),
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            // Star rating
            Row(
              children: List.generate(5, (i) => Icon(
                Icons.star_rounded,
                size: 14,
                color: i < log.qualityRating
                    ? const Color(0xFFFFD700)
                    : AppColors.surfaceMuted,
              )),
            ),
          ],
        ),
      ),
    );
  }
}




