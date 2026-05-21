import 'package:firebase_auth/firebase_auth.dart';
import 'package:isar/isar.dart';
import '../models/user_profile.dart';
import '../services/isar_service.dart';

class UserProfileRepository {
  final _db = IsarService.db;

  // Get the current Firebase uid
  // Every method uses this to scope queries to the right user
  String? get _currentUid => FirebaseAuth.instance.currentUser?.uid;

  Future<void> saveProfile(UserProfile profile) async {
    // Always stamp the uid before saving
    // This ensures the record is linked to the current Firebase user
    final uid = _currentUid;
    if (uid != null) profile.uid = uid;

    await _db.writeTxn(() async {
      await _db.userProfiles.put(profile);
    });
  }

  // READ — finds the profile for the CURRENT signed-in user only
  // Returns null if this user has no profile yet
  Future<UserProfile?> getProfile() async {
    final uid = _currentUid;
    if (uid == null) return null;

    // Query by uid — not by Isar auto ID
    // This correctly finds Person A's profile for Person A
    // and Person B's profile for Person B — even on the same phone
    return _db.userProfiles
        .filter()
        .uidEqualTo(uid)
        .findFirst();
  }

  // DELETE — only deletes the current user's profile
  // Does not touch other users' profiles on the same device
  Future<void> deleteProfile() async {
    final uid = _currentUid;
    if (uid == null) return;

    await _db.writeTxn(() async {
      final profile = await getProfile();
      if (profile != null) {
        await _db.userProfiles.delete(profile.id);
      }
    });
  }

  // WATCH — live stream for the current user's profile only
  Stream<UserProfile?> watchProfile() {
    final uid = _currentUid;
    if (uid == null) return Stream.value(null);

    return _db.userProfiles
        .filter()
        .uidEqualTo(uid)
        .watch(fireImmediately: true)
        .map((list) => list.isEmpty ? null : list.first);
  }
}