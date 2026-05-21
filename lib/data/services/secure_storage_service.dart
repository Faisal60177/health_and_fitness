import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Android options: use encrypted SharedPreferences
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // Keys — using constants avoids typo bugs
  static const _keyUserId = 'user_id';
  static const _keyOnboardingDone = 'onboarding_done';

  // Save the Firebase UID after login
  static Future<void> saveUserId(String uid) async {
    await _storage.write(key: _keyUserId, value: uid);
  }

  static Future<String?> getUserId() async {
    return _storage.read(key: _keyUserId);
  }

  // Track whether user has completed onboarding
  static Future<void> setOnboardingDone() async {
    await _storage.write(key: _keyOnboardingDone, value: 'true');
  }

  static Future<bool> isOnboardingDone() async {
    final val = await _storage.read(key: _keyOnboardingDone);
    return val == 'true';
  }

  // Called on logout — wipes all secure data
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}