import 'package:isar/isar.dart';

part 'food_log.g.dart';

// Meal type enum stored as int in Isar
enum MealType {
  breakfast,
  lunch,
  dinner,
  snack,
}

// One food item logged by the user
@collection
class FoodLog {
  Id id = Isar.autoIncrement;

  @Index()
  late String uid;

  late DateTime date;
  late String foodName;       // "Chicken Breast"
  late double calories;
  late double proteinG;       // grams of protein
  late double carbsG;         // grams of carbohydrates
  late double fatG;           // grams of fat
  late double servingSize;    // in grams
  @enumerated                 // stores enum as int index
  late MealType mealType;

  // Macro percentages — used for the breakdown ring chart in Phase 4
  // Total calories from macros: protein=4kcal/g, carbs=4kcal/g, fat=9kcal/g
  double get proteinCalories => proteinG * 4;
  double get carbCalories => carbsG * 4;
  double get fatCalories => fatG * 9;
}