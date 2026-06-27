import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth_state.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/services/background_sync_service.dart';
import '../../../data/services/sync_service.dart';
import 'package:health_and_fitness/data/services/step_foreground_service.dart';

// ── Repository provider ────────────────────────────────────────
final authRepositoryProvider = Provider<AuthRepository>(
      (_) => AuthRepository(),
);

// ── Auth stream provider (used by router) ──────────────────────
final authStateProvider = StreamProvider<User?>(
      (ref) => ref.watch(authRepositoryProvider).authStateChanges,
);

// ── Main auth notifier ─────────────────────────────────────────
final authNotifierProvider =
NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository _repo;

  @override
  AuthState build() {
    _repo = ref.read(authRepositoryProvider);
    _init();
    return const AuthState();
  }

  void _init() {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loadUserData(user);
      } else {
        state = const AuthState(isLoggedIn: false);
      }
    });
  }

  Future<void> _loadUserData(User user) async {
    final hasPassword =
    user.providerData.any((p) => p.providerId == 'password');
    final hasGoogle =
    user.providerData.any((p) => p.providerId == 'google.com');

    state = state.copyWith(
      isLoggedIn:  true,
      displayName: user.displayName ?? '',
      email:       user.email       ?? '',
      hasPassword: hasPassword,
      hasGoogle:   hasGoogle,
      photoUrl:    user.photoURL    ?? '',
    );
  }

  // ── Post sign-in sync ──────────────────────────────────────────
  Future<void> _postSignInSync(String uid) async {
    await BackgroundSyncService.register();
    await StepForegroundService.start();

    final syncService  = SyncService();
    final needsRestore = await syncService.needsRestore(uid);

    if (needsRestore) {
      await syncService.sync(
        direction: SyncDirection.download,
        daysBack:  90,
      );
    } else {
      await syncService.sync(
        direction: SyncDirection.upload,
        daysBack:  7,
      );
    }
  }

  // ── SIGN UP ────────────────────────────────────────────────────
  Future<bool> signUp(String email, String password, String name) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: '');
      await _repo.signUp(email: email, password: password, name: name);
      await BackgroundSyncService.register();
      return true;
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // ── LOGIN ──────────────────────────────────────────────────────
  Future<bool> login(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: '');
      final user = await _repo.login(email: email, password: password);
      await _postSignInSync(user.uid);
      return true;
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // ── GOOGLE SIGN IN ─────────────────────────────────────────────
// ── GOOGLE SIGN IN ─────────────────────────────────────────────
  Future<bool> signInWithGoogle() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: '');
      final user = await _repo.signInWithGoogle();
      await _postSignInSync(user.uid);
      return true;
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      if (msg.isEmpty) return false; // user canceled
      state = state.copyWith(errorMessage: msg);
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // ── UPDATE PROFILE ─────────────────────────────────────────────
  Future<bool> updateProfile({required String name}) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: '');
      await _repo.updateProfile(name: name);
      state = state.copyWith(displayName: name.trim());
      return true;
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // ── ADD PASSWORD ───────────────────────────────────────────────
  Future<bool> addPasswordToAccount({required String password}) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: '');
      await _repo.addPasswordToAccount(password: password);
      state = state.copyWith(hasPassword: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // ── PASSWORD RESET ─────────────────────────────────────────────
  Future<bool> sendPasswordReset(String email) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: '');
      await _repo.sendPasswordReset(email);
      return true;
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // ── LOGOUT ─────────────────────────────────────────────────────
  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: '');
      await BackgroundSyncService.cancel();
      await StepForegroundService.stop();

      try {
        await SyncService().sync(
          direction: SyncDirection.upload,
          daysBack:  30,
        );
      } catch (_) {}

      await _repo.logout();
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}