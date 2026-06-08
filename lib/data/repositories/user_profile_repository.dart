import 'package:health_and_fitness/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import '../models/user_profile.dart';
import '../services/objectbox_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileRepository {
  Box<UserProfile> get _box => ObjectBoxService.userProfiles;

  String? get _currentUid =>
      FirebaseAuth.instance.currentUser?.uid;

  Future<void> saveProfile(UserProfile profile) async {
    final uid = _currentUid;
    if (uid != null) profile.uid = uid;
    _box.put(profile);
  }

  Future<UserProfile?> getProfile() async {
    final uid = _currentUid;
    if (uid == null) return null;
    return _box.query(UserProfile_.uid.equals(uid))
        .build().findFirst();
  }

  Future<void> deleteProfile() async {
    final profile = await getProfile();
    if (profile != null) _box.remove(profile.id);
  }

  Stream<UserProfile?> watchProfile() {
    final uid = _currentUid;
    if (uid == null) return Stream.value(null);
    return _box.query(UserProfile_.uid.equals(uid))
        .watch(triggerImmediately: true)
        .map((q) => q.findFirst());
  }
}




