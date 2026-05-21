import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/services/sync_service.dart';

part 'sync_provider.g.dart';

// Tracks the sync status shown in the UI
class SyncState {
  final bool        isSyncing;
  final SyncResult? lastResult;
  final DateTime?   lastSyncAt;

  const SyncState({
    this.isSyncing  = false,
    this.lastResult,
    this.lastSyncAt,
  });

  SyncState copyWith({
    bool?        isSyncing,
    SyncResult?  lastResult,
    DateTime?    lastSyncAt,
  }) {
    return SyncState(
      isSyncing:  isSyncing  ?? this.isSyncing,
      lastResult: lastResult ?? this.lastResult,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }
}

@riverpod
class SyncNotifier extends _$SyncNotifier {
  final _service = SyncService();

  @override
  SyncState build() => const SyncState();

  // Manual sync — called from Settings or pull-to-refresh
  Future<void> syncNow() async {
    if (state.isSyncing) return; // prevent double sync

    state = state.copyWith(isSyncing: true);

    final result = await _service.sync(
      direction: SyncDirection.both,
      daysBack:  30,
    );

    state = state.copyWith(
      isSyncing:  false,
      lastResult: result,
      lastSyncAt: DateTime.now(),
    );
  }

  // Upload only — called after user logs tracking data
  // Lighter than full sync — only pushes, doesn't download
  Future<void> uploadChanges() async {
    await _service.sync(
      direction: SyncDirection.upload,
      daysBack:  7, // just last week for quick syncs
    );
  }

  // Restore from cloud — called on new device sign-in
  Future<void> restoreFromCloud() async {
    state = state.copyWith(isSyncing: true);

    final result = await _service.sync(
      direction: SyncDirection.download,
      daysBack:  90, // restore 3 months on new device
    );

    state = state.copyWith(
      isSyncing:  false,
      lastResult: result,
      lastSyncAt: DateTime.now(),
    );
  }

  // Check and restore if new device
  Future<bool> checkAndRestoreIfNeeded(String uid) async {
    final needsRestore = await _service.needsRestore(uid);
    if (needsRestore) {
      await restoreFromCloud();
      return true; // restored
    }
    return false; // already had local data
  }
}