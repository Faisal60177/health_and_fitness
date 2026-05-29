import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/secure_storage_service.dart';

class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  // v7: use singleton, no constructor
  GoogleSignIn get _googleSignIn => GoogleSignIn.instance;

  // ── EMAIL SIGN UP ──────────────────────────────────────────────
  Future<User> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email:    email.trim(),
        password: password,
      );
      await credential.user!.updateDisplayName(name.trim());
      await credential.user!.reload();
      await SecureStorageService.saveUserId(credential.user!.uid);
      return _firebaseAuth.currentUser!;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleFirebaseError(e));
    } catch (_) {
      throw Exception('Sign up failed. Please try again.');
    }
  }

  // ── EMAIL LOGIN ────────────────────────────────────────────────
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email:    email.trim(),
        password: password,
      );
      await SecureStorageService.saveUserId(credential.user!.uid);
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
        throw Exception(
          'Incorrect email or password.\n'
              'If you signed up with Google, use "Continue with Google" instead.',
        );
      }
      throw Exception(_handleFirebaseError(e));
    } catch (_) {
      throw Exception('Login failed. Please try again.');
    }
  }

  // ── GOOGLE SIGN IN ─────────────────────────────────────────────
  // v7 API — initialize() must be called once at app startup
  Future<User> signInWithGoogle() async {
    try {
      // v7: authenticate() replaces signIn()
      // Always shows account picker (sign out first)
      try {
        await _googleSignIn.signOut();
      } catch (_) {}

      if (!_googleSignIn.supportsAuthenticate()) {
        throw Exception(
          'Google Sign-In is not supported on this platform.',
        );
      }

      final GoogleSignInAccount googleUser =
      await _googleSignIn.authenticate();

      // idToken requires serverClientId set in initialize()
      final String? idToken = googleUser.authentication.idToken;
      if (idToken == null) {
        throw Exception(
          'Google sign-in failed: idToken is null. '
              'Check your SHA-1 fingerprint and serverClientId.',
        );
      }

      // accessToken from authorizationClient on the account object (v7)
      final clientAuth =
          await googleUser.authorizationClient.authorizationForScopes(
            ['email', 'profile'],
          ) ??
              await googleUser.authorizationClient.authorizeScopes(
                ['email', 'profile'],
              );

      final googleCredential = GoogleAuthProvider.credential(
        idToken:     idToken,
        accessToken: clientAuth?.accessToken,
      );

      final userCredential =
      await _firebaseAuth.signInWithCredential(googleCredential);

      // Ensure display name is set
      final user = userCredential.user!;
      if (user.displayName == null || user.displayName!.isEmpty) {
        await user.updateDisplayName(googleUser.displayName ?? '');
        await user.reload();
      }

      await SecureStorageService.saveUserId(_firebaseAuth.currentUser!.uid);
      return _firebaseAuth.currentUser!;
    } on GoogleSignInException catch (e) {
      // User dismissed picker — silent
      if (e.code.name == 'canceled') {
        throw Exception('');
      }
      throw Exception('Google sign-in failed. Please try again.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw Exception(
          'This email is already registered with a password.\n'
              'Please sign in with your email and password instead.',
        );
      }
      throw Exception(_handleFirebaseError(e));
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Google sign-in failed. Please try again.');
    }
  }

  // ── INITIALIZE Google Sign-In (call once in main.dart) ─────────
  // Must be called before any Google sign-in attempt
  static Future<void> initializeGoogleSignIn({
    required String webClientId,
  }) async {
    try {
      await GoogleSignIn.instance.initialize(
        serverClientId: webClientId,
      );
    } catch (_) {
      // Non-fatal — user can still attempt sign-in manually
    }
  }

  // ── LINK Google to email+password account ──────────────────────
  Future<void> linkGoogleToCurrentAccount() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) throw Exception('No user signed in.');

      try {
        await _googleSignIn.signOut();
      } catch (_) {}

      final GoogleSignInAccount googleUser =
      await _googleSignIn.authenticate();

      final String? idToken = googleUser.authentication.idToken;
      if (idToken == null) throw Exception('Google idToken is null.');

      final clientAuth =
          await googleUser.authorizationClient.authorizationForScopes(
            ['email', 'profile'],
          ) ??
              await googleUser.authorizationClient.authorizeScopes(
                ['email', 'profile'],
              );

      final googleCredential = GoogleAuthProvider.credential(
        idToken:     idToken,
        accessToken: clientAuth?.accessToken,
      );

      await currentUser.linkWithCredential(googleCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        throw Exception(
            'This Google account is already linked to another user.');
      }
      if (e.code == 'provider-already-linked') {
        throw Exception('Google is already linked to your account.');
      }
      throw Exception(_handleFirebaseError(e));
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to link Google account.');
    }
  }

  // ── CHECK providers ────────────────────────────────────────────
  bool get isGoogleLinked {
    final user = _firebaseAuth.currentUser;
    if (user == null) return false;
    return user.providerData.any((p) => p.providerId == 'google.com');
  }

  bool get isEmailLinked {
    final user = _firebaseAuth.currentUser;
    if (user == null) return false;
    return user.providerData.any((p) => p.providerId == 'password');
  }

  // ── LOGOUT ─────────────────────────────────────────────────────
  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await Future.wait([
      _firebaseAuth.signOut(),
      SecureStorageService.clearAll(),
    ]);
  }

  // ── PASSWORD RESET ─────────────────────────────────────────────
  Future<void> sendPasswordReset(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleFirebaseError(e));
    }
  }

  // ── AUTH STATE STREAM ──────────────────────────────────────────
  Stream<User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  // ── ERROR MESSAGES ─────────────────────────────────────────────
  String _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'user-not-found':
        return 'No account found with this email. Please sign up first.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait and try again.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network.';
      case 'account-exists-with-different-credential':
        return 'This email is registered with a different sign-in method.';
      case 'credential-already-in-use':
        return 'This credential is already linked to another account.';
      case 'provider-already-linked':
        return 'This sign-in method is already linked to your account.';
      case 'requires-recent-login':
        return 'Please sign in again before making this change.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      default:
        return 'Something went wrong: ${e.message ?? e.code}';
    }
  }
}