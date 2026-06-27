import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/secure_storage_service.dart';

// ⚠️ Replace with HealthFit's web client ID from google-services.json
// Find it in google-services.json → client → oauth_client → client_id
// (the one ending in .apps.googleusercontent.com with client_type: 3)
const String _kWebClientId =
    '1099427515724-b1mj1hiv1g1ubipknvn4rqmhohcgl614.apps.googleusercontent.com';

class AuthRepository {
  final _auth      = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  GoogleSignIn get _googleSignIn => GoogleSignIn.instance;

  // ── Auth state stream (used by router) ────────────────────────
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  // ── Initialize Google Sign-In (call once in main.dart) ────────
  static Future<void> initializeGoogleSignIn() async {
    try {
      await GoogleSignIn.instance.initialize(
        serverClientId: _kWebClientId,
      );
      GoogleSignIn.instance.authenticationEvents
          .listen((_) {})
          .onError((_) {});
      GoogleSignIn.instance.attemptLightweightAuthentication();
    } catch (_) {}
  }

  // ── Helpers ───────────────────────────────────────────────────

  Future<List<String>> _getProvidersFromFirestore(String email) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('email', isEqualTo: email.trim())
          .limit(1)
          .get();
      if (query.docs.isEmpty) return [];
      final raw = query.docs.first.data()['providers'];
      if (raw is List)   return List<String>.from(raw);
      if (raw is String) return [raw];
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<({
  AuthCredential credential,
  String email,
  String displayName,
  String photoUrl,
  })> _getGoogleCredential() async {
    try { await _googleSignIn.signOut(); } catch (_) {}

    if (!_googleSignIn.supportsAuthenticate()) {
      throw Exception('Google Sign-In is not supported on this platform.');
    }

    final googleUser = await _googleSignIn.authenticate(
      scopeHint: ['email', 'profile'],
    );

    final String? idToken = googleUser.authentication.idToken;
    if (idToken == null) {
      throw Exception(
        'Google sign-in failed: idToken is null. '
            'Check SHA-1 fingerprint and serverClientId in Firebase Console.',
      );
    }

    final clientAuth =
        await googleUser.authorizationClient
            .authorizationForScopes(['email', 'profile']) ??
            await googleUser.authorizationClient
                .authorizeScopes(['email', 'profile']);

    final credential = GoogleAuthProvider.credential(
      idToken:     idToken,
      accessToken: clientAuth?.accessToken,
    );

    return (
    credential:  credential,
    email:       googleUser.email,
    displayName: googleUser.displayName ?? '',
    photoUrl:    googleUser.photoUrl    ?? '',
    );
  }

  // ── EMAIL SIGN UP ──────────────────────────────────────────────
  Future<User> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential credential;
      try {
        credential = await _auth.createUserWithEmailAndPassword(
          email:    email.trim(),
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          final providers = await _getProvidersFromFirestore(email.trim());
          if (providers.contains('password')) {
            throw Exception(
                'This email is already registered. Please sign in instead.');
          }
          // Google-only account — link password to it
          return await _linkPasswordToExistingAccount(
            email: email.trim(), password: password, name: name.trim(),
          );
        }
        rethrow;
      }

      final user = credential.user!;
      await user.updateDisplayName(name.trim());

      await _firestore.collection('users').doc(user.uid).set({
        'uid':       user.uid,
        'name':      name.trim(),
        'email':     email.trim(),
        'photoUrl':  '',
        'providers': ['password'],
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      });

      await SecureStorageService.saveUserId(user.uid);
      return _auth.currentUser!;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e.code));
    }
  }

  // ── EMAIL LOGIN ────────────────────────────────────────────────
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email:    email.trim(),
        password: password,
      );

      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .update({'lastLogin': FieldValue.serverTimestamp()});

      await SecureStorageService.saveUserId(credential.user!.uid);
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
        final providers = await _getProvidersFromFirestore(email);
        if (providers.contains('google') && !providers.contains('password')) {
          throw Exception(
            'This account uses Google sign-in only. '
                'Use "Continue with Google" instead.',
          );
        }
        throw Exception('Incorrect email or password. Please try again.');
      }
      throw Exception(_mapFirebaseError(e.code));
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Login failed. Please try again.');
    }
  }

  // ── GOOGLE SIGN IN ─────────────────────────────────────────────
  Future<User> signInWithGoogle() async {
    final google    = await _getGoogleCredential();
    final providers = await _getProvidersFromFirestore(google.email);

    if (providers.isEmpty) {
      return await _completeGoogleSignIn(
        google.credential, google.email,
        google.displayName, google.photoUrl,
        isNew: true,
      );
    }

    if (providers.contains('google') && !providers.contains('password')) {
      return await _completeGoogleSignIn(
        google.credential, google.email,
        google.displayName, google.photoUrl,
        isNew: false,
      );
    }

    if (providers.contains('password')) {
      return await _signInAndLinkGoogle(
        google.credential, google.email,
        google.displayName, google.photoUrl,
      );
    }

    throw Exception('Google sign-in failed. Please try again.');
  }

  Future<User> _completeGoogleSignIn(
      AuthCredential credential,
      String googleEmail,
      String googleName,
      String googlePhoto, {
        required bool isNew,
      }) async {
    final userCred = await _auth.signInWithCredential(credential);
    final user     = userCred.user!;

    if (isNew) {
      await _firestore.collection('users').doc(user.uid).set({
        'uid':       user.uid,
        'name':      user.displayName ?? googleName,
        'email':     user.email       ?? googleEmail,
        'photoUrl':  user.photoURL    ?? googlePhoto,
        'providers': ['google'],
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      });
    } else {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({'lastLogin': FieldValue.serverTimestamp()});
    }

    await SecureStorageService.saveUserId(user.uid);
    return _auth.currentUser!;
  }

  Future<User> _signInAndLinkGoogle(
      AuthCredential googleCredential,
      String googleEmail,
      String googleName,
      String googlePhoto,
      ) async {
    try {
      final userCred = await _auth.signInWithCredential(googleCredential);
      final user     = userCred.user!;

      final alreadyLinked =
      user.providerData.any((p) => p.providerId == 'google.com');
      if (!alreadyLinked) {
        await user.linkWithCredential(googleCredential);
      }

      await _firestore.collection('users').doc(user.uid).update({
        'providers': FieldValue.arrayUnion(['google']),
        'photoUrl':  user.photoURL ?? googlePhoto,
        'lastLogin': FieldValue.serverTimestamp(),
      });

      await SecureStorageService.saveUserId(user.uid);
      return _auth.currentUser!;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'provider-already-linked') return _auth.currentUser!;
      throw Exception(_mapFirebaseError(e.code));
    }
  }

  Future<User> _linkPasswordToExistingAccount({
    required String email,
    required String password,
    required String name,
  }) async {
    final google = await _getGoogleCredential();

    if (google.email.toLowerCase() != email.toLowerCase()) {
      throw Exception(
          'The Google account selected does not match the email entered.');
    }

    final userCred = await _auth.signInWithCredential(google.credential);
    final user     = userCred.user!;

    final alreadyHasPassword =
    user.providerData.any((p) => p.providerId == 'password');

    if (!alreadyHasPassword) {
      final emailCred = EmailAuthProvider.credential(
        email: email, password: password,
      );
      await user.linkWithCredential(emailCred);
    }

    await _firestore.collection('users').doc(user.uid).update({
      'providers': FieldValue.arrayUnion(['password']),
      'lastLogin': FieldValue.serverTimestamp(),
    });

    await SecureStorageService.saveUserId(user.uid);
    return _auth.currentUser!;
  }

  // ── LINK Google to existing account ───────────────────────────
  Future<void> linkGoogleToCurrentAccount() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('No user signed in.');

    final google = await _getGoogleCredential();

    final alreadyLinked =
    currentUser.providerData.any((p) => p.providerId == 'google.com');
    if (!alreadyLinked) {
      await currentUser.linkWithCredential(google.credential);
    }

    await _firestore.collection('users').doc(currentUser.uid).update({
      'providers': FieldValue.arrayUnion(['google']),
      'photoUrl':  currentUser.photoURL ?? google.photoUrl,
      'lastLogin': FieldValue.serverTimestamp(),
    });
  }

  // ── PASSWORD RESET ─────────────────────────────────────────────
  Future<void> sendPasswordReset(String email) async {
    final providers = await _getProvidersFromFirestore(email);
    if (providers.contains('google') && !providers.contains('password')) {
      throw Exception(
          'This account uses Google sign-in. Use "Continue with Google".');
    }
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e.code));
    }
  }

  // ── UPDATE PROFILE ─────────────────────────────────────────────
  Future<void> updateProfile({required String name}) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user signed in.');
    await Future.wait([
      _firestore.collection('users').doc(user.uid)
          .update({'name': name.trim()}),
      user.updateDisplayName(name.trim()),
    ]);
  }

  // ── ADD/UPDATE PASSWORD ────────────────────────────────────────
  Future<void> addPasswordToAccount({required String password}) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user signed in.');

    await user.reload();
    final freshUser     = _auth.currentUser!;
    final alreadyLinked =
    freshUser.providerData.any((p) => p.providerId == 'password');

    if (alreadyLinked) {
      try {
        await freshUser.updatePassword(password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          // Re-auth with Google then retry
          final google = await _getGoogleCredential();
          await freshUser.reauthenticateWithCredential(google.credential);
          await _auth.currentUser!.updatePassword(password);
        } else {
          throw Exception(_mapFirebaseError(e.code));
        }
      }
    } else {
      final emailCred = EmailAuthProvider.credential(
        email:    freshUser.email!,
        password: password,
      );
      await freshUser.linkWithCredential(emailCred);
      await _firestore.collection('users').doc(freshUser.uid).update({
        'providers': FieldValue.arrayUnion(['password']),
      });
    }
  }

  // ── CHECK PROVIDERS ────────────────────────────────────────────
  bool get isGoogleLinked {
    final user = _auth.currentUser;
    if (user == null) return false;
    return user.providerData.any((p) => p.providerId == 'google.com');
  }

  bool get isEmailLinked {
    final user = _auth.currentUser;
    if (user == null) return false;
    return user.providerData.any((p) => p.providerId == 'password');
  }

  // ── LOGOUT ─────────────────────────────────────────────────────
  Future<void> logout() async {
    try { await _googleSignIn.signOut(); } catch (_) {}
    await Future.wait([
      _auth.signOut(),
      SecureStorageService.clearAll(),
    ]);
  }

  // ── ERROR MAPPING ──────────────────────────────────────────────
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':           return 'No account found with this email.';
      case 'wrong-password':
      case 'invalid-credential':       return 'Incorrect password. Please try again.';
      case 'email-already-in-use':     return 'This email is already registered.';
      case 'weak-password':            return 'Password must be at least 6 characters.';
      case 'invalid-email':            return 'Please enter a valid email address.';
      case 'too-many-requests':        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':   return 'Network error. Please check your connection.';
      case 'provider-already-linked':  return 'This sign-in method is already linked.';
      case 'requires-recent-login':    return 'Please sign in again before making this change.';
      case 'credential-already-in-use':return 'This Google account is already linked to another user.';
      case 'user-disabled':            return 'This account has been disabled.';
      default:                         return 'Something went wrong. Please try again.';
    }
  }
}