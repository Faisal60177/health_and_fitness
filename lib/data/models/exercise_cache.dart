import 'package:isar/isar.dart';

part 'exercise_cache.g.dart';

// Caches API exercise data locally so the app works offline
// and doesn't hammer the API on every screen open
@collection
class ExerciseCache {
  Id id = Isar.autoIncrement;

  // The wger API uses numeric IDs
  late int apiId;
  late String name;
  late String description;
  late String category;         // 'Chest', 'Back', 'Legs'...
  late String equipment;        // 'Barbell', 'Dumbbell', 'Bodyweight'
  late List<String> muscles;    // primary muscles targeted
  late List<String> musclesSecondary;
  late String gifUrl;           // animated GIF from the API
  late DateTime cachedAt;       // when this was fetched — for staleness check

  ExerciseCache() {
    muscles          = [];
    musclesSecondary = [];
  }

  // Stale after 7 days — triggers re-fetch
  bool get isStale =>
      DateTime.now().difference(cachedAt).inDays > 7;
}