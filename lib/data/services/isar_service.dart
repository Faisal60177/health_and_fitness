import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user_profile.dart';
import '../models/workout_log.dart';
import '../models/step_entry.dart';
import '../models/food_log.dart';
import '../models/water_log.dart';
import '../models/weight_log.dart';
import '../models/sleep_log.dart';
import '../models/exercise_cache.dart';
import '../models/meal_plan.dart';
import '../models/workout_plan.dart';
import 'package:health_and_fitness/data/models/user_goals.dart';


// This class is the single gateway to your Isar database
// Using a singleton ensures only ONE database connection exists
class IsarService {
  static late Isar _isar;  // the actual database instance

  // Call this ONCE in main() before runApp()
  // It opens the database file on disk
  static Future<void> initialize() async {
    // getApplicationDocumentsDirectory() returns the app's private folder
    // On Android: /data/data/com.yourapp/files/
    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open(
      [
        UserProfileSchema,
        WorkoutSessionSchema,
        StepEntrySchema,
        FoodLogSchema,
        WaterLogSchema,
        WeightLogSchema,
        SleepLogSchema,
        WorkoutPlanSchema,
        RecipeSchema,
        MealPlanSchema,
        ExerciseCacheSchema,
        UserGoalsSchema,

      ],  // tell Isar which collections to create

      directory: dir.path,
    );
  }

  // Expose the db instance for repository classes to use
  static Isar get db => _isar;
}
