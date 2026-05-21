import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/sync_provider.dart';

class SyncCard extends ConsumerWidget {
  const SyncCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sync = ref.watch(syncNotifierProvider);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.cloud_sync_rounded,
                    color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Cloud Sync',
                        style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600)),
                    Text(
                      sync.lastSyncAt != null
                          ? 'Last synced ${_timeAgo(sync.lastSyncAt!)}'
                          : 'Not synced yet',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              // Sync now button
              GestureDetector(
                onTap: sync.isSyncing
                    ? null
                    : () => ref.read(syncNotifierProvider.notifier).syncNow(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: sync.isSyncing
                        ? AppColors.surfaceMuted
                        : AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: sync.isSyncing
                            ? AppColors.surfaceMuted
                            : AppColors.primary.withOpacity(0.4)),
                  ),
                  child: sync.isSyncing
                      ? const SizedBox(
                      width: 14, height: 14,
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary))
                      : const Text(
                    'Sync now',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),

          // Last result
          if (sync.lastResult != null) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: sync.lastResult!.success
                    ? AppColors.success.withOpacity(0.08)
                    : AppColors.danger.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    sync.lastResult!.success
                        ? Icons.check_circle_outline_rounded
                        : Icons.error_outline_rounded,
                    size: 14,
                    color: sync.lastResult!.success
                        ? AppColors.success
                        : AppColors.danger,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    sync.lastResult!.success
                        ? '${sync.lastResult!.recordsSynced} records synced'
                        : sync.lastResult!.message,
                    style: TextStyle(
                      fontSize: 12,
                      color: sync.lastResult!.success
                          ? AppColors.success
                          : AppColors.danger,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // What is synced explanation
          const SizedBox(height: 12),
          const Text(
            'Syncs steps, workouts, food, water, sleep and weight. '
                'Restores your data automatically on any new device.',
            style: TextStyle(
                fontSize: 11,
                color: AppColors.textHint,
                height: 1.5),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1)  return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24)   return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}