import 'dart:convert';
import 'package:objectbox/objectbox.dart';


// Not an @Entity — stored as JSON inside Recipe
class RecipeIngredient {
  String name   = '';
  double amount = 0;
  String unit   = '';

  RecipeIngredient();

  Map<String, dynamic> toJson() =>
      {'name': name, 'amount': amount, 'unit': unit};

  factory RecipeIngredient.fromJson(Map<String, dynamic> j) =>
      RecipeIngredient()
        ..name   = j['name']   as String? ?? ''
        ..amount = (j['amount'] as num?)?.toDouble() ?? 0
        ..unit   = j['unit']   as String? ?? '';
}

@Entity()
class Recipe {
  int id = 0;

  @Index()
  String uid = '';

  late String name;
  late String description;
  late String category;
  late int    prepMinutes;
  late int    cookMinutes;
  late int    servings;
  late double caloriesPerServing;
  late double proteinG;
  late double carbsG;
  late double fatG;
  String imageUrl  = '';
  String tagsJson = '[]';
  String ingredientsJson   = '[]';
  String instructionsJson  = '[]';

  List<String> get tags =>
      (jsonDecode(tagsJson) as List).cast<String>();
  set tags(List<String> v) =>
      tagsJson = jsonEncode(v);

  List<RecipeIngredient> get ingredients {
    final list = jsonDecode(ingredientsJson) as List;
    return list
        .map((e) => RecipeIngredient.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  set ingredients(List<RecipeIngredient> v) =>
      ingredientsJson = jsonEncode(v.map((e) => e.toJson()).toList());

  List<String> get instructions =>
      (jsonDecode(instructionsJson) as List).cast<String>();
  set instructions(List<String> v) =>
      instructionsJson = jsonEncode(v);

  String get totalTime => '${prepMinutes + cookMinutes} min';
}

@Entity()
class MealPlan {
  int id = 0;

  @Index()
  String uid = '';

  late String   name;
  late String   description;
  late String   goal;
  late int      dailyCalorieTarget;
  late int      durationDays;
  @Property(type: PropertyType.date)
  late DateTime createdAt;
  bool isActive = false;

  String recipeIdsJson = '[]';

  List<String> get recipeIds =>
      (jsonDecode(recipeIdsJson) as List).cast<String>();
  set recipeIds(List<String> v) =>
      recipeIdsJson = jsonEncode(v);
}





