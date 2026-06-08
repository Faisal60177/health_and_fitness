import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../objectbox.g.dart';
import '../models/step_entry.dart';
import '../models/workout_log.dart';
import '../models/food_log.dart';
import '../models/water_log.dart';
import '../models/sleep_log.dart';
import '../models/weight_log.dart';
import '../models/user_profile.dart';
import '../repositories/step_repository.dart';
import '../repositories/workout_repository.dart';
import '../repositories/food_repository.dart';
import '../repositories/water_repository.dart';
import '../repositories/sleep_repository.dart';
import '../repositories/weight_repository.dart';
import '../repositories/user_profile_repository.dart';
import 'objectbox_service.dart';

enum SyncDirection {
  upload,
  download,
  both,
}

class SyncResult {
  final bool success;
  final String message;
  final int recordsSynced;
  final DateTime completedAt;

  const SyncResult({
    required this.success,
    required this.message,
    required this.recordsSynced,
    required this.completedAt,
  });
}

class SyncService {
  final _firestore = FirebaseFirestore.instance;
  final _auth      = FirebaseAuth.instance;

  Future<SyncResult> sync({
    SyncDirection direction = SyncDirection.both,
    int daysBack = 30,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      return SyncResult(
        success:       false,
        message:       'No user signed in',
        recordsSynced: 0,
        completedAt:   DateTime.now(),
      );
    }

    try {
      int totalSynced = 0;

      if (direction == SyncDirection.upload ||
          direction == SyncDirection.both) {
        totalSynced += await _uploadToFirestore(user.uid, daysBack);
      }

      if (direction == SyncDirection.download ||
          direction == SyncDirection.both) {
        totalSynced += await _downloadFromFirestore(user.uid, daysBack);
      }

      await _userDoc(user.uid).update({
        'lastSyncAt': FieldValue.serverTimestamp(),
      });

      return SyncResult(
        success:       true,
        message:       'Synced $totalSynced records',
        recordsSynced: totalSynced,
        completedAt:   DateTime.now(),
      );
    } catch (e) {
      debugPrint('SyncService error: $e');
      return SyncResult(
        success:       false,
        message:       'Sync failed: $e',
        recordsSynced: 0,
        completedAt:   DateTime.now(),
      );
    }
  }

  // ── UPLOAD: ObjectBox → Firestore ─────────────────────────────

  Future<int> _uploadToFirestore(String uid, int daysBack) async {
    int count = 0;
    count += await _uploadProfile(uid);
    final results = await Future.wait([
      _uploadSteps(uid, daysBack),
      _uploadWorkouts(uid, daysBack),
      _uploadFood(uid, daysBack),
      _uploadWater(uid, daysBack),
      _uploadSleep(uid, daysBack),
      _uploadWeight(uid, daysBack),
    ]);
    count += results.fold(0, (sum, r) => sum + r);
    return count;
  }

  Future<int> _uploadProfile(String uid) async {
    final profile = await UserProfileRepository().getProfile();
    if (profile == null) return 0;

    await _userDoc(uid).set({
      'name':         profile.name,
      'email':        profile.email,
      'age':          profile.age,
      'weightKg':     profile.weightKg,
      'heightCm':     profile.heightCm,
      'fitnessGoal':  profile.fitnessGoal,
      'fitnessLevel': profile.fitnessLevel,
      'updatedAt':    FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return 1;
  }

  Future<int> _uploadSteps(String uid, int daysBack) async {
    final entries = await StepRepository().getRecentDays(daysBack);
    if (entries.isEmpty) return 0;

    final batch    = _firestore.batch();
    final stepsRef = _trackingCollection(uid, 'steps');

    for (final entry in entries) {
      final docId  = _dateKey(entry.date);
      final docRef = stepsRef.doc(docId);
      batch.set(docRef, {
        'stepCount': entry.stepCount,
        'dailyGoal': entry.dailyGoal,
        'date':      Timestamp.fromDate(entry.date),
        'syncedAt':  FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    await batch.commit();
    return entries.length;
  }

  Future<int> _uploadWorkouts(String uid, int daysBack) async {
    final sessions = await WorkoutRepository().getAllSessions();
    if (sessions.isEmpty) return 0;

    final cutoff = DateTime.now().subtract(Duration(days: daysBack));
    final recent = sessions.where((s) => s.date.isAfter(cutoff)).toList();
    if (recent.isEmpty) return 0;

    final batch       = _firestore.batch();
    final workoutsRef = _trackingCollection(uid, 'workouts');

    for (final session in recent) {
      // ObjectBox uses int id same as Isar
      final docRef = workoutsRef.doc(session.id.toString());

      final exercisesJson = session.exercises.map((ex) => {
        'name':        ex.name,
        'muscleGroup': ex.muscleGroup,
        'sets': ex.sets.map((s) => {
          'weightKg':        s.weightKg,
          'reps':            s.reps,
          'durationSeconds': s.durationSeconds,
          'isCompleted':     s.isCompleted,
        }).toList(),
      }).toList();

      batch.set(docRef, {
        'name':            session.name,
        'date':            Timestamp.fromDate(session.date),
        'durationMinutes': session.durationMinutes,
        'exercises':       exercisesJson,
        'notes':           session.notes,
        'syncedAt':        FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    await batch.commit();
    return recent.length;
  }

  Future<int> _uploadFood(String uid, int daysBack) async {
    final cutoff  = DateTime.now().subtract(Duration(days: daysBack));
    final entries = await FoodRepository().getLogsForDate(cutoff);
    if (entries.isEmpty) return 0;

    final chunks = _chunk(entries, 400);
    for (final chunk in chunks) {
      final batch   = _firestore.batch();
      final foodRef = _trackingCollection(uid, 'food');

      for (final entry in chunk) {
        final docRef = foodRef.doc(entry.id.toString());
        batch.set(docRef, {
          'foodName': entry.foodName,
          'calories': entry.calories,
          'proteinG': entry.proteinG,
          'carbsG':   entry.carbsG,
          'fatG':     entry.fatG,
          'mealType': entry.mealType.index,
          'date':     Timestamp.fromDate(entry.date),
          'syncedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      await batch.commit();
    }

    return entries.length;
  }

  Future<int> _uploadWater(String uid, int daysBack) async {
    final entries = await WaterRepository().getTodayLogs();
    if (entries.isEmpty) return 0;

    final batch    = _firestore.batch();
    final waterRef = _trackingCollection(uid, 'water');

    for (final entry in entries) {
      final docRef = waterRef.doc(entry.id.toString());
      batch.set(docRef, {
        'amountMl': entry.amountML,
        'date':     Timestamp.fromDate(entry.date),
        'time':     Timestamp.fromDate(entry.time),
        'syncedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    await batch.commit();
    return entries.length;
  }

  Future<int> _uploadSleep(String uid, int daysBack) async {
    final entries = await SleepRepository().getRecentNights(daysBack);
    if (entries.isEmpty) return 0;

    final batch    = _firestore.batch();
    final sleepRef = _trackingCollection(uid, 'sleep');

    for (final entry in entries) {
      final docRef = sleepRef.doc(entry.id.toString());
      batch.set(docRef, {
        'bedTime':       Timestamp.fromDate(entry.bedTime),
        'wakeTime':      Timestamp.fromDate(entry.wakeTime),
        'qualityRating': entry.qualityRating,
        'notes':         entry.notes,
        'date':          Timestamp.fromDate(entry.date),
        'syncedAt':      FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    await batch.commit();
    return entries.length;
  }

  Future<int> _uploadWeight(String uid, int daysBack) async {
    final all    = await WeightRepository().getHistory();
    final cutoff = DateTime.now().subtract(Duration(days: daysBack));
    final recent = all.where((w) => w.date.isAfter(cutoff)).toList();
    if (recent.isEmpty) return 0;

    final batch     = _firestore.batch();
    final weightRef = _trackingCollection(uid, 'weight');

    for (final entry in recent) {
      final docRef = weightRef.doc(entry.id.toString());
      batch.set(docRef, {
        'weightKg': entry.weightKg,
        'notes':    entry.notes,
        'date':     Timestamp.fromDate(entry.date),
        'syncedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    await batch.commit();
    return recent.length;
  }

  // ── DOWNLOAD: Firestore → ObjectBox ───────────────────────────

  Future<int> _downloadFromFirestore(String uid, int daysBack) async {
    int count = 0;
    final results = await Future.wait([
      _downloadProfile(uid),
      _downloadSteps(uid, daysBack),
      _downloadWorkouts(uid, daysBack),
      _downloadFood(uid, daysBack),
      _downloadWater(uid, daysBack),
      _downloadSleep(uid, daysBack),
      _downloadWeight(uid, daysBack),
    ]);
    count = results.fold(0, (sum, r) => sum + r);
    return count;
  }

  Future<int> _downloadProfile(String uid) async {
    final doc = await _userDoc(uid).get();
    if (!doc.exists || doc.data() == null) return 0;

    final data    = doc.data()!;
    final repo    = UserProfileRepository();
    var   profile = await repo.getProfile();

    profile ??= UserProfile();
    profile
      ..name         = data['name']         as String? ?? ''
      ..email        = data['email']        as String? ?? ''
      ..age          = data['age']          as int?    ?? 25
      ..weightKg     = (data['weightKg']    as num?)?.toDouble() ?? 70
      ..heightCm     = (data['heightCm']    as num?)?.toDouble() ?? 170
      ..fitnessGoal  = data['fitnessGoal']  as String? ?? 'maintain'
      ..fitnessLevel = data['fitnessLevel'] as String? ?? 'beginner'
      ..createdAt    = DateTime.now();

    await repo.saveProfile(profile);
    return 1;
  }

  Future<int> _downloadSteps(String uid, int daysBack) async {
    final cutoff   = DateTime.now().subtract(Duration(days: daysBack));
    final snapshot = await _trackingCollection(uid, 'steps')
        .where('date', isGreaterThan: Timestamp.fromDate(cutoff))
        .get();

    if (snapshot.docs.isEmpty) return 0;

    // ObjectBox — no transactions, just put directly
    final box = ObjectBoxService.stepEntries;

    for (final doc in snapshot.docs) {
      final data     = doc.data();
      final date     = (data['date'] as Timestamp).toDate();
      final dayStart = DateTime(date.year, date.month, date.day);

      // Check if date already exists using ObjectBox query
      final existing = box
          .query(StepEntry_.date.equals(dayStart.millisecondsSinceEpoch))
          .build()
          .findFirst();

      if (existing != null) {
        // Cloud has more steps — use cloud value
        if ((data['stepCount'] as int) > existing.stepCount) {
          existing.stepCount = data['stepCount'] as int;
          box.put(existing);
        }
      } else {
        // No local record — create from cloud
        final entry = StepEntry()
          ..date      = dayStart
          ..stepCount = data['stepCount'] as int
          ..dailyGoal = data['dailyGoal'] as int? ?? 10000;
        box.put(entry);
      }
    }

    return snapshot.docs.length;
  }

  Future<int> _downloadWorkouts(String uid, int daysBack) async {
    final cutoff   = DateTime.now().subtract(Duration(days: daysBack));
    final snapshot = await _trackingCollection(uid, 'workouts')
        .where('date', isGreaterThan: Timestamp.fromDate(cutoff))
        .get();

    if (snapshot.docs.isEmpty) return 0;

    final box = ObjectBoxService.workoutSessions;

    for (final doc in snapshot.docs) {
      final data    = doc.data();
      final localId = int.tryParse(doc.id);

      // Skip if already exists locally
      if (localId != null && box.get(localId) != null) continue;

      final exercisesData = data['exercises'] as List<dynamic>? ?? [];
      final exercises = exercisesData.map((exData) {
        final setsData = (exData['sets'] as List<dynamic>? ?? []);
        final sets = setsData.map((s) {
          return WorkoutSet.create(
            weightKg:        (s['weightKg'] as num?)?.toDouble() ?? 0,
            reps:            s['reps']    as int? ?? 0,
            durationSeconds: s['durationSeconds'] as int? ?? 0,
          );
        }).toList();

        return WorkoutExercise(
          name:        exData['name']        as String? ?? '',
          muscleGroup: exData['muscleGroup'] as String? ?? '',
          sets:        sets,
        );
      }).toList();

      final session = WorkoutSession()
        ..name            = data['name']            as String? ?? ''
        ..date            = (data['date'] as Timestamp).toDate()
        ..durationMinutes = data['durationMinutes'] as int? ?? 0
        ..exercises       = exercises
        ..notes           = data['notes']           as String? ?? '';

      box.put(session);
    }

    return snapshot.docs.length;
  }

  Future<int> _downloadFood(String uid, int daysBack) async {
    final cutoff   = DateTime.now().subtract(Duration(days: daysBack));
    final snapshot = await _trackingCollection(uid, 'food')
        .where('date', isGreaterThan: Timestamp.fromDate(cutoff))
        .get();

    if (snapshot.docs.isEmpty) return 0;

    final box = ObjectBoxService.foodLogs;

    for (final doc in snapshot.docs) {
      final data    = doc.data();
      final localId = int.tryParse(doc.id);

      if (localId != null && box.get(localId) != null) continue;

      final entry = FoodLog()
        ..foodName    = data['foodName'] as String? ?? ''
        ..calories    = (data['calories'] as num?)?.toDouble() ?? 0
        ..proteinG    = (data['proteinG'] as num?)?.toDouble() ?? 0
        ..carbsG      = (data['carbsG']   as num?)?.toDouble() ?? 0
        ..fatG        = (data['fatG']     as num?)?.toDouble() ?? 0
        ..mealType    = MealType.values[data['mealType'] as int? ?? 3]
        ..date        = (data['date'] as Timestamp).toDate()
        ..servingSize = 100;

      box.put(entry);
    }

    return snapshot.docs.length;
  }

  Future<int> _downloadWater(String uid, int daysBack) async {
    final cutoff   = DateTime.now().subtract(Duration(days: daysBack));
    final snapshot = await _trackingCollection(uid, 'water')
        .where('date', isGreaterThan: Timestamp.fromDate(cutoff))
        .get();

    if (snapshot.docs.isEmpty) return 0;

    final box = ObjectBoxService.waterLogs;

    for (final doc in snapshot.docs) {
      final data    = doc.data();
      final localId = int.tryParse(doc.id);

      if (localId != null && box.get(localId) != null) continue;

      final log = WaterLog()
        ..amountML = data['amountMl'] as int? ?? 0
        ..date     = (data['date'] as Timestamp).toDate()
        ..time     = (data['time'] as Timestamp?)?.toDate() ?? DateTime.now();

      box.put(log);
    }

    return snapshot.docs.length;
  }

  Future<int> _downloadSleep(String uid, int daysBack) async {
    final cutoff   = DateTime.now().subtract(Duration(days: daysBack));
    final snapshot = await _trackingCollection(uid, 'sleep')
        .where('date', isGreaterThan: Timestamp.fromDate(cutoff))
        .get();

    if (snapshot.docs.isEmpty) return 0;

    final box = ObjectBoxService.sleepLogs;

    for (final doc in snapshot.docs) {
      final data    = doc.data();
      final localId = int.tryParse(doc.id);

      if (localId != null && box.get(localId) != null) continue;

      final log = SleepLog()
        ..bedTime       = (data['bedTime']  as Timestamp).toDate()
        ..wakeTime      = (data['wakeTime'] as Timestamp).toDate()
        ..qualityRating = data['qualityRating'] as int? ?? 3
        ..notes         = data['notes']         as String? ?? ''
        ..date          = (data['date'] as Timestamp).toDate();

      box.put(log);
    }

    return snapshot.docs.length;
  }

  Future<int> _downloadWeight(String uid, int daysBack) async {
    final cutoff   = DateTime.now().subtract(Duration(days: daysBack));
    final snapshot = await _trackingCollection(uid, 'weight')
        .where('date', isGreaterThan: Timestamp.fromDate(cutoff))
        .get();

    if (snapshot.docs.isEmpty) return 0;

    final box = ObjectBoxService.weightLogs;

    for (final doc in snapshot.docs) {
      final data    = doc.data();
      final localId = int.tryParse(doc.id);

      if (localId != null && box.get(localId) != null) continue;

      final log = WeightLog()
        ..weightKg = (data['weightKg'] as num?)?.toDouble() ?? 0
        ..notes    = data['notes']  as String? ?? ''
        ..date     = (data['date'] as Timestamp).toDate();

      box.put(log);
    }

    return snapshot.docs.length;
  }

  // ── CHECK if new device ────────────────────────────────────────

  Future<bool> needsRestore(String uid) async {
    // ObjectBox — count all step entries
    final localSteps = ObjectBoxService.stepEntries.count();
    if (localSteps > 0) return false;

    final doc = await _userDoc(uid).get();
    return doc.exists;
  }

  // ── HELPERS ───────────────────────────────────────────────────

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _firestore.collection('users').doc(uid);

  CollectionReference<Map<String, dynamic>> _trackingCollection(
      String uid, String type) =>
      _userDoc(uid).collection('tracking').doc(type).collection(type);

  List<List<T>> _chunk<T>(List<T> list, int maxSize) {
    final chunks = <List<T>>[];
    for (var i = 0; i < list.length; i += maxSize) {
      chunks.add(list.sublist(
          i, i + maxSize > list.length ? list.length : i + maxSize));
    }
    return chunks;
  }

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}



