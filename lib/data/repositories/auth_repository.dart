import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/secure_storage_service.dart';

class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  // ── EMAIL SIGN UP ──────────────────────────────────────────────
  Future<User> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email:    email,
        password: password,
      );

      await credential.user!.updateDisplayName(name);
      await credential.user!.reload();
      await SecureStorageService.saveUserId(credential.user!.uid);
      return _firebaseAuth.currentUser!;

    } on FirebaseAuthException catch (e) {
      throw Exception(_handleFirebaseError(e));
    } catch (e) {
      throw Exception('Sign up failed. Please try again.');
    }
  }

  // ── EMAIL LOGIN ────────────────────────────────────────────────
  // Strategy: just attempt login, catch errors and show smart messages.
  // Firebase v10+ returns 'invalid-credential' for wrong password AND
  // for Google-only accounts — we handle both in the catch block.
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email:    email,
        password: password,
      );

      await SecureStorageService.saveUserId(credential.user!.uid);
      return credential.user!;

    } on FirebaseAuthException catch (e) {
      // 'invalid-credential' covers:
      //   - wrong password
      //   - user doesn't exist
      //   - Google-only account trying email+pass
      // We give a helpful message that covers all cases
      if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
        throw Exception(
          'Incorrect email or password.\n'
              'If you signed up with Google, use "Continue with Google" instead.',
        );
      }
      throw Exception(_handleFirebaseError(e));
    } catch (e) {
      throw Exception('Login failed. Please try again.');
    }
  }

  // ── GOOGLE SIGN IN ─────────────────────────────────────────────
  // Strategy: signInWithCredential handles ALL cases automatically:
  //   Case 1 - New user:         creates account + signs in
  //   Case 2 - Existing Google:  signs in normally
  //   Case 3 - Email+pass user:  throws 'account-exists-with-different-credential'
  //                              which we catch and guide them to use password
  Future<User> signInWithGoogle() async {
    try {
      // Step 1: Trigger Google account picker
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google sign-in was cancelled.');

      // Step 2: Get Google auth tokens
      final googleAuth = await googleUser.authentication;
      final googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken:     googleAuth.idToken,
      );

      // Step 3: Sign in to Firebase with Google credential
      final userCredential =
      await _firebaseAuth.signInWithCredential(googleCredential);

      // Step 4: Ensure display name is always set
      if (userCredential.user!.displayName == null ||
          userCredential.user!.displayName!.isEmpty) {
        await userCredential.user!.updateDisplayName(googleUser.displayName);
        await userCredential.user!.reload();
      }

      await SecureStorageService.saveUserId(
          _firebaseAuth.currentUser!.uid);
      return _firebaseAuth.currentUser!;

    } on FirebaseAuthException catch (e) {
      // This fires when Firebase console has
      // "One account per email" ON and email already
      // exists under email+password provider
      if (e.code == 'account-exists-with-different-credential') {
        throw Exception(
          'This email is already registered with a password.\n'
              'Please sign in with your email and password instead.',
        );
      }
      throw Exception(_handleFirebaseError(e));
    } catch (e) {
      // Re-throw our own exceptions (like cancelled)
      if (e is Exception) rethrow;
      throw Exception('Google sign-in failed. Please try again.');
    }
  }

  // ── LINK Google TO email+password account ──────────────────────
  // Optional: call this from a Settings screen so users who signed
  // up with email+pass can ALSO use Google to sign in going forward.
  // After linking, both methods work for the same account.
  Future<void> linkGoogleToCurrentAccount() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) throw Exception('No user is currently signed in.');

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google sign-in was cancelled.');

      final googleAuth = await googleUser.authentication;
      final googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken:     googleAuth.idToken,
      );

      // linkWithCredential adds Google as a second sign-in method
      // to the existing email+password account
      await currentUser.linkWithCredential(googleCredential);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        throw Exception(
            'This Google account is already linked to a different user.');
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

  // ── CHECK if Google is linked to current account ───────────────
  // Use this to show/hide "Link Google Account" button in Settings
  bool get isGoogleLinked {
    final user = _firebaseAuth.currentUser;
    if (user == null) return false;
    return user.providerData
        .any((info) => info.providerId == 'google.com');
  }

  // ── CHECK if email+password is linked ─────────────────────────
  bool get isEmailLinked {
    final user = _firebaseAuth.currentUser;
    if (user == null) return false;
    return user.providerData
        .any((info) => info.providerId == 'password');
  }

  // ── LOGOUT ─────────────────────────────────────────────────────
  Future<void> logout() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
      SecureStorageService.clearAll(),
    ]);
  }

  // ── PASSWORD RESET ─────────────────────────────────────────────
  Future<void> sendPasswordReset(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleFirebaseError(e));
    }
  }

  // ── AUTH STATE ─────────────────────────────────────────────────
  Stream<User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  // ── READABLE ERROR MESSAGES ────────────────────────────────────
  String _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'An account already exists with this email.\n'
            'Try signing in, or use "Continue with Google" if you registered with Google.';
      case 'user-not-found':
        return 'No account found with this email. Please sign up first.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Incorrect email or password.\n'
            'If you signed up with Google, use "Continue with Google" instead.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please wait a moment and try again.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network.';
      case 'account-exists-with-different-credential':
        return 'This email is registered with a different sign-in method.\n'
            'Please use your email and password to sign in.';
      case 'credential-already-in-use':
        return 'This credential is already linked to another account.';
      case 'provider-already-linked':
        return 'This sign-in method is already linked to your account.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled. Please contact support.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      default:
        return 'Something went wrong: ${e.message ?? e.code}';
    }
  }
}