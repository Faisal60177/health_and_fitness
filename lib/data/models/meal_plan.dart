import 'package:isar/isar.dart';

part 'meal_plan.g.dart';

@embedded
class RecipeIngredient {
  late String name;
  late double amount;
  late String unit;             // 'g', 'ml', 'cup', 'tbsp'

  RecipeIngredient();
}

@collection
class Recipe {
  Id id = Isar.autoIncrement;

  @Index()
  late String uid;

  late String name;
  late String description;
  late String category;         // 'breakfast', 'lunch', 'dinner', 'snack'
  late int prepMinutes;
  late int cookMinutes;
  late int servings;
  late double caloriesPerServing;
  late double proteinG;
  late double carbsG;
  late double fatG;
  late List<RecipeIngredient> ingredients;
  late List<String> instructions;   // step-by-step
  String imageUrl = '';
  List<String> tags = [];           // 'high-protein', 'vegan', 'quick'

  Recipe() {
    ingredients  = [];
    instructions = [];
  }

  String get totalTime => '${prepMinutes + cookMinutes} min';
}

@collection
class MealPlan {
  Id id = Isar.autoIncrement;

  @Index()
  late String uid;

  late String name;
  late String description;
  late String goal;             // 'weight_loss', 'muscle_gain', 'maintenance'
  late int dailyCalorieTarget;
  late int durationDays;        // 7, 14, 28
  late List<String> recipeIds;  // IDs of recipes in this plan
  late DateTime createdAt;
  bool isActive = false;

  MealPlan() { recipeIds = []; }
}