import 'package:isar/isar.dart';

part 'meal_plan.g.dart';

@embedded
class RecipeIngredient {
  late String name;
  late double amount;
  late String unit;
  RecipeIngredient();
}

@collection
class Recipe {
  Id id = Isar.autoIncrement;

  // FIX: was 'late String uid' — templates seeded without uid set
  // caused LateInitializationError on first read
  @Index()
  String uid = '';

  late String name;
  late String description;
  late String category;
  late int prepMinutes;
  late int cookMinutes;
  late int servings;
  late double caloriesPerServing;
  late double proteinG;
  late double carbsG;
  late double fatG;
  late List<RecipeIngredient> ingredients;
  late List<String> instructions;
  String imageUrl = '';
  List<String> tags = [];

  Recipe() {
    ingredients  = [];
    instructions = [];
  }

  String get totalTime => '${prepMinutes + cookMinutes} min';
}

@collection
class MealPlan {
  Id id = Isar.autoIncrement;

  // FIX: same issue
  @Index()
  String uid = '';

  late String name;
  late String description;
  late String goal;
  late int dailyCalorieTarget;
  late int durationDays;
  late List<String> recipeIds;
  late DateTime createdAt;
  bool isActive = false;

  MealPlan() { recipeIds = []; }
}