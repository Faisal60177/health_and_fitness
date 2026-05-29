import 'package:isar/isar.dart';

part 'food_log.g.dart';

enum MealType {
  breakfast,
  lunch,
  dinner,
  snack,
}

@collection
class FoodLog {
  Id id = Isar.autoIncrement;

  // FIX: was 'late String uid'
  @Index()
  String uid = '';

  late DateTime date;
  late String foodName;
  late double calories;
  late double proteinG;
  late double carbsG;
  late double fatG;
  late double servingSize;
  @enumerated
  late MealType mealType;

  double get proteinCalories => proteinG * 4;
  double get carbCalories    => carbsG   * 4;
  double get fatCalories     => fatG     * 9;
}