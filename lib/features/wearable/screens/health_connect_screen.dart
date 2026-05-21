import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/health_connect_service.dart';

part 'health_connect_screen.g.dart';

// State for Health Connect data
class HealthData {
  final int    steps;
  final double sleepHours;
  final double? heartRate;
  final bool   isConnected;

  const HealthData({
    this.steps       = 0,
    this.sleepHours  = 0,
    this.heartRate,
    this.isConnected = false,
  });
}

@riverpod
class HealthConnectNotifier extends _$HealthConnectNotifier {
  final _service = HealthConnectService();

  @override
  HealthData build() => const HealthData();

  Future<void> connect() async {
    final granted = await _service.requestPermissions();
    if (!granted) return;

    final results = await Future.wait([
      _service.getTodaySteps(),
      _service.getLastSleepHours(),
      _service.getLatestHeartRate(),
    ]);

    state = HealthData(
      steps:       results[0] as int,
      sleepHours:  results[1] as double,
      heartRate:   results[2] as double?,
      isConnected: true,
    );
  }

  Future<void> refresh() async {
    if (!state.isConnected) return;
    await connect();
  }
}

class HealthConnectScreen extends ConsumerWidget {
  const HealthConnectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(healthConnectNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Health Connect',
            style: TextStyle(color: AppColors.textPrimary)),
        actions: [
          if (data.isConnected)
            IconButton(
              icon: const Icon(Icons.refresh_rounded,
                  color: AppColors.textSecondary),
              onPressed: () =>
                  ref.read(healthConnectNotifierProvider.notifier).refresh(),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surfaceMuted),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.monitor_heart_rounded,
                        color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Google Health Connect',
                            style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 15)),
                        const SizedBox(height: 4),
                        Text(
                          data.isConnected
                              ? 'Connected — syncing your data'
                              : 'Sync with Google Fit, Fitbit, Samsung Health',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            if (!data.isConnected) ...[
              // Not connected — show connect button
              Text('What syncs', style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              ...[
                ('Steps', 'Daily step count from your phone or watch',
                Icons.directions_walk_rounded),
                ('Sleep', 'Sleep duration from wearables',
                Icons.bedtime_rounded),
                ('Heart rate', 'BPM readings from smartwatch',
                Icons.favorite_rounded),
              ].map((item) => _SyncItem(
                label: item.$1,
                desc:  item.$2,
                icon:  item.$3,
              )),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => ref
                      .read(healthConnectNotifierProvider.notifier)
                      .connect(),
                  icon: const Icon(Icons.link_rounded),
                  label: const Text('Connect Health Connect'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ] else ...[
              // Connected — show synced data
              Text('Synced data', style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _DataCard(
                    icon:  Icons.directions_walk_rounded,
                    label: 'Steps',
                    value: '${data.steps}',
                    unit:  'today',
                    color: AppColors.primary,
                  ),
                  _DataCard(
                    icon:  Icons.bedtime_rounded,
                    label: 'Sleep',
                    value: data.sleepHours.toStringAsFixed(1),
                    unit:  'hours',
                    color: const Color(0xFF7C3AED),
                  ),
                  if (data.heartRate != null)
                    _DataCard(
                      icon:  Icons.favorite_rounded,
                      label: 'Heart Rate',
                      value: data.heartRate!.toStringAsFixed(0),
                      unit:  'BPM',
                      color: AppColors.danger,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SyncItem extends StatelessWidget {
  final String label;
  final String desc;
  final IconData icon;
  const _SyncItem({required this.label, required this.desc, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodyLarge),
                Text(desc,  style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          const Icon(Icons.check_circle_rounded,
              color: AppColors.success, size: 18),
        ],
      ),
    );
  }
}

class _DataCard extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String   value;
  final String   unit;
  final Color    color;

  const _DataCard({
    required this.icon,  required this.label,
    required this.value, required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: color)),
              Text(unit, style: const TextStyle(
                  fontSize: 11, color: AppColors.textHint)),
            ],
          ),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}