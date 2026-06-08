import 'package:objectbox/objectbox.dart';


enum MealType { breakfast, lunch, dinner, snack }

@Entity()
class FoodLog {
  int id = 0;

  @Index()
  String uid = '';

  @Property(type: PropertyType.date)
  late DateTime date;
  late String foodName;
  late double calories;
  late double proteinG;
  late double carbsG;
  late double fatG;
  late double servingSize;
  late int mealTypeIndex; // store enum as int

  MealType get mealType => MealType.values[mealTypeIndex];
  set mealType(MealType v) => mealTypeIndex = v.index;

  double get proteinCalories => proteinG * 4;
  double get carbCalories    => carbsG   * 4;
  double get fatCalories     => fatG     * 9;
}




