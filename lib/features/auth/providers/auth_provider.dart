import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/services/background_sync_service.dart';
import '../../../data/services/sync_service.dart';
import '../../../data/services/secure_storage_service.dart';
import 'package:health_and_fitness/data/services/step_foreground_service.dart';

part 'auth_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) => AuthRepository();

@riverpod
Stream<User?> authState(Ref ref) =>
    ref.watch(authRepositoryProvider).authStateChanges;

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> signUp(String email, String password, String name) async {
    state = const AsyncLoading();
    try {
      final user = await ref.read(authRepositoryProvider).signUp(
        email:    email,
        password: password,
        name:     name,
      );
      // New user — no cloud data to restore
      // Register background sync for future sessions
      await BackgroundSyncService.register();
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      final user = await ref.read(authRepositoryProvider).login(
        email:    email,
        password: password,
      );
      // Returning user — check if this is a new device and restore
      await _postSignInSync(user.uid);
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    try {
      final user = await ref.read(authRepositoryProvider).signInWithGoogle();
      await _postSignInSync(user.uid);
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  // Called after every successful sign-in
  // Checks if Isar is empty and restores from Firestore if needed
  Future<void> _postSignInSync(String uid) async {
    // Register background daily sync
    await BackgroundSyncService.register();
    await StepForegroundService.start();

    // Check if this is a new device (Isar empty but Firestore has data)
    final syncService = SyncService();
    final needsRestore = await syncService.needsRestore(uid);

    if (needsRestore) {
      // New device — download everything from cloud into Isar
      // This runs in the foreground so user sees their data immediately
      await syncService.sync(
        direction: SyncDirection.download,
        daysBack:  90, // restore 3 months of history
      );
    } else {
      // Same device — just upload any new changes to keep cloud current
      await syncService.sync(
        direction: SyncDirection.upload,
        daysBack:  7,
      );
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    try {
      await BackgroundSyncService.cancel();
      await StepForegroundService.stop();

      // Upload ALL pending data before wiping anything
      try {
        final syncService = SyncService();
        await syncService.sync(
          direction: SyncDirection.upload,
          daysBack: 30, // catch everything logged this month
        );
      } catch (_) {
        // Don't block logout if sync fails (offline, etc.)
      }

      await ref.read(authRepositoryProvider).logout();
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}






