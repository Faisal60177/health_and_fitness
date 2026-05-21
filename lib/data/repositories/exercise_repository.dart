import 'package:isar/isar.dart';
import '../models/exercise_cache.dart';
import '../services/exercise_api_service.dart';
import '../services/isar_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExerciseRepository {
  final _db = IsarService.db;

  // Single helper — gets current uid once, used by all methods
  String get _uid =>
      FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';


  Future<List<ExerciseCache>> getExercises({
    String? categoryId,
    String  searchTerm  = '',
    bool    forceRefresh = false,
  }) async {
    // 1. Cache-first (skip if search term or force refresh)
    if (!forceRefresh && searchTerm.isEmpty) {
      final cached = await _getCachedByCategory(categoryId);
      if (cached.isNotEmpty && !cached.first.isStale) {
        return cached;
      }
    }

    // 2. Fetch from ExerciseDB API
    final apiExercises = await ExerciseApiService.fetchExercises(
      category:   categoryId,
      searchTerm: searchTerm,
      limit:      30,
    );

    if (apiExercises.isEmpty) {
      // Network failed or rate limited — return stale cache
      return _getCachedByCategory(categoryId);
    }

    // 3. Convert to cache models
    // ExerciseDB already has gifUrl in the response — no second call needed
    final cacheModels = apiExercises
        .map((ex) => _toCacheModel(ex))
        .toList();

    // 4. Save to Isar
    await _saveToCache(cacheModels);

    return cacheModels;
  }

  Future<List<ExerciseCache>> search(String query) async {
    // Try Isar text search first (instant, offline)
    final localResults = await _db.exerciseCaches
        .filter()
        .nameContains(query, caseSensitive: false)
        .findAll();

    if (localResults.isNotEmpty) return localResults;

    // Fall back to API search
    final apiResults = await ExerciseApiService.searchExercises(query);
    if (apiResults.isEmpty) return [];

    final cacheModels = apiResults.map(_toCacheModel).toList();
    await _saveToCache(cacheModels);
    return cacheModels;
  }

  Future<ExerciseCache?> getById(int apiId) async {
    final cached = await _db.exerciseCaches
        .filter()
        .apiIdEqualTo(apiId)
        .findFirst();

    if (cached != null && !cached.isStale) return cached;

    // Fetch from API by string ID (ExerciseDB uses zero-padded strings)
    final paddedId = apiId.toString().padLeft(4, '0');
    final result   = await ExerciseApiService.fetchById(paddedId);
    if (result == null) return cached; // return stale if unavailable

    final model = _toCacheModel(result);
    await _saveToCache([model]);
    return model;
  }

  Future<List<ExerciseCache>> _getCachedByCategory(
      String? categoryId) async {
    if (categoryId == null) {
      return _db.exerciseCaches.where().findAll();
    }
    // Map category ID → ExerciseDB body part display name
    final bodyPart = ExerciseApiService.categoryMap[categoryId] ?? '';
    if (bodyPart.isEmpty) return _db.exerciseCaches.where().findAll();

    return _db.exerciseCaches
        .filter()
    // ExerciseDB bodyPart becomes our 'category' field
    // stored as capitalized: 'Upper Arms', 'Upper Legs' etc.
        .categoryContains(
      bodyPart.split(' ').map((w) {
        if (w.isEmpty) return w;
        return w[0].toUpperCase() + w.substring(1);
      }).join(' '),
      caseSensitive: false,
    )
        .findAll();
  }

  Future<void> _saveToCache(List<ExerciseCache> exercises) async {
    if (exercises.isEmpty) return;
    await _db.writeTxn(() async {
      await _db.exerciseCaches.putAll(exercises);
    });
  }

  // Convert API model → Isar model
  // gifUrl comes directly from ExerciseDB response
  ExerciseCache _toCacheModel(ApiExercise ex) {
    return ExerciseCache()
      ..apiId            = ex.id
      ..name             = ex.name
      ..description      = ex.description
      ..category         = ex.category
      ..equipment        = ex.equipment
      ..muscles          = ex.muscles
      ..musclesSecondary = ex.musclesSecondary
      ..gifUrl           = ex.gifUrl    // ← already populated, no 2nd fetch
      ..cachedAt         = DateTime.now();
  }
}