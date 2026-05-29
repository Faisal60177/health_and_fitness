import 'package:isar/isar.dart';
import '../models/meal_plan.dart';
import '../services/isar_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MealRepository {
  final _db = IsarService.db;

  // Single helper — gets current uid once, used by all methods
  String get _uid =>
      FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

  // ── Recipes ──────────────────────────────────────────────

  Future<void> saveRecipe(Recipe recipe) async {
    // Only stamp uid on user-created recipes
    // Built-in templates keep uid = '' so all users see them
    if (recipe.id == 0) {
      // New user-created recipe — stamp their uid
      // id == 0 means not yet saved to Isar (Isar auto-assign hasn't run)
      // Templates are seeded with uid = '' already
    }

    await _db.writeTxn(() async {
      await _db.recipes.put(recipe);
    });
  }

  Future<List<Recipe>> getAllRecipes() async {
    return _db.recipes
        .filter()
        .uidEqualTo('')            // built-in templates — uid is empty string
        .or()
        .uidEqualTo(_uid)         // this user's custom recipes
        .findAll();
  }

  // Filter by category: 'breakfast', 'lunch', 'dinner', 'snack'
  Future<List<Recipe>> getRecipesByCategory(String category) async {
    return _db.recipes
        .filter()
        .group((q) => q            // group the uid OR condition
        .uidEqualTo('')
        .or()
        .uidEqualTo(_uid))
        .and()
        .categoryEqualTo(category)
        .findAll();
  }

  // Filter by goal tag: 'high-protein', 'vegan', 'quick', 'low-carb'
  Future<List<Recipe>> getRecipesByTag(String tag) async {
    return _db.recipes
        .filter()
        .group((q) => q
        .uidEqualTo('')
        .or()
        .uidEqualTo(_uid))
        .and()
        .tagsElementContains(tag)
        .findAll();
  }

  // Search recipes by name
  Future<List<Recipe>> searchRecipes(String query) async {
    return _db.recipes
        .filter()
        .group((q) => q
        .uidEqualTo('')
        .or()
        .uidEqualTo(_uid))
        .and()
        .nameContains(query, caseSensitive: false)
        .findAll();
  }

  Future<Recipe?> getRecipeById(int id) async {
    return _db.recipes.get(id);
  }

  Future<void> deleteRecipe(int id) async {
    await _db.writeTxn(() async {
      await _db.recipes.delete(id);
    });
  }

  // ── Meal Plans ────────────────────────────────────────────

  Future<void> saveMealPlan(MealPlan plan) async {
    // Stamp uid when activating a user plan
    // Templates keep uid = '' so all users see them
    if (plan.isActive && plan.uid.isEmpty) {
      plan.uid = _uid;
    }
    await _db.writeTxn(() async {
      await _db.mealPlans.put(plan);
    });
  }

  Future<List<MealPlan>> getAllMealPlans() async {
    return _db.mealPlans
        .filter()
        .uidEqualTo('')            // built-in templates
        .or()
        .uidEqualTo(_uid)         // this user's active/custom plans
        .findAll();
  }

  Future<MealPlan?> getActivePlan() async {
    return _db.mealPlans
        .filter()
        .uidEqualTo(_uid)         // only THIS user's active plan
        .isActiveEqualTo(true)
        .findFirst();
  }

  // Activate one plan — deactivates all others first
  Future<void> activatePlan(int planId) async {
    await _db.writeTxn(() async {
      // Deactivate only THIS user's currently active plans
      final myPlans = await _db.mealPlans
          .filter()
          .uidEqualTo(_uid)
          .findAll();
      for (final p in myPlans) {
        if (p.isActive) {
          p.isActive = false;
          await _db.mealPlans.put(p);
        }
      }
      // Activate the chosen plan and stamp uid
      final target = await _db.mealPlans.get(planId);
      if (target != null) {
        target.isActive = true;
        target.uid      = _uid;   // ← stamp uid when user activates
        await _db.mealPlans.put(target);
      }
    });
  }

  Future<void> deactivatePlan(int planId) async {
    await _db.writeTxn(() async {
      final plan = await _db.mealPlans.get(planId);
      if (plan != null) {
        plan.isActive = false;
        await _db.mealPlans.put(plan);
      }
    });
  }

  // Returns all recipes belonging to a meal plan
  // recipeIds are stored as String on MealPlan — parse to int for lookup
  Future<List<Recipe>> getRecipesForPlan(MealPlan plan) async {
    final ids = plan.recipeIds
        .map((s) => int.tryParse(s))
        .whereType<int>()
        .toList();

    if (ids.isEmpty) return [];

    final recipes = <Recipe>[];
    for (final id in ids) {
      final r = await _db.recipes.get(id);
      if (r != null) recipes.add(r);
    }
    return recipes;
  }

  // ── Seed built-in data if DB is empty ───────────────────

  Future<void> seedIfEmpty() async {
    final count = await _db.recipes.count();
    if (count > 0) return; // already seeded

    final recipes = _buildRecipes();
    await _db.writeTxn(() async {
      await _db.recipes.putAll(recipes);
    });

    // Build meal plans referencing the saved recipe IDs
    final savedRecipes = await getAllRecipes();
    final plans = _buildMealPlans(savedRecipes);
    await _db.writeTxn(() async {
      await _db.mealPlans.putAll(plans);
    });
  }

  // ── Built-in Recipe Library ───────────────────────────────

  List<Recipe> _buildRecipes() {
    return [
      // ── BREAKFAST ──────────────────────
      _recipe(
        name: 'Greek Yogurt Protein Bowl',
        desc: 'High-protein breakfast to kickstart muscle recovery.',
        category: 'breakfast',
        prep: 5, cook: 0, servings: 1,
        cal: 380, protein: 32, carbs: 42, fat: 8,
        ingredients: [
          _ing('Greek yogurt (0% fat)', 200, 'g'),
          _ing('Mixed berries', 80, 'g'),
          _ing('Granola', 40, 'g'),
          _ing('Honey', 15, 'g'),
          _ing('Chia seeds', 10, 'g'),
        ],
        instructions: [
          'Add Greek yogurt to a bowl.',
          'Top with mixed berries and granola.',
          'Drizzle honey over the top.',
          'Sprinkle chia seeds and serve immediately.',
        ],
        tags: ['high-protein', 'quick', 'no-cook'],
      ),

      _recipe(
        name: 'Oats & Banana Power Smoothie',
        desc: 'Quick pre-workout fuel — ready in 3 minutes.',
        category: 'breakfast',
        prep: 3, cook: 0, servings: 1,
        cal: 420, protein: 18, carbs: 68, fat: 7,
        ingredients: [
          _ing('Rolled oats', 60, 'g'),
          _ing('Banana', 1, 'unit'),
          _ing('Milk (semi-skimmed)', 250, 'ml'),
          _ing('Protein powder (vanilla)', 30, 'g'),
          _ing('Peanut butter', 15, 'g'),
          _ing('Ice cubes', 4, 'unit'),
        ],
        instructions: [
          'Combine all ingredients in a blender.',
          'Blend on high for 60 seconds.',
          'Pour into a glass and drink immediately.',
          'Optional: top with banana slices.',
        ],
        tags: ['high-protein', 'quick', 'pre-workout'],
      ),

      _recipe(
        name: 'Veggie Egg White Omelette',
        desc: 'Low-calorie, high-protein breakfast for fat loss.',
        category: 'breakfast',
        prep: 5, cook: 8, servings: 1,
        cal: 210, protein: 26, carbs: 8, fat: 6,
        ingredients: [
          _ing('Egg whites', 5, 'unit'),
          _ing('Spinach', 60, 'g'),
          _ing('Cherry tomatoes', 80, 'g'),
          _ing('Bell pepper', 50, 'g'),
          _ing('Feta cheese', 20, 'g'),
          _ing('Olive oil', 5, 'ml'),
          _ing('Salt & pepper', 1, 'pinch'),
        ],
        instructions: [
          'Heat olive oil in a non-stick pan over medium heat.',
          'Add bell pepper and sauté 2 minutes.',
          'Add spinach and cook until wilted (1 minute).',
          'Pour egg whites over vegetables.',
          'Cook 3–4 minutes until edges set.',
          'Add halved cherry tomatoes and feta.',
          'Fold omelette in half and slide onto plate.',
        ],
        tags: ['low-calorie', 'high-protein', 'low-carb'],
      ),

      // ── LUNCH ──────────────────────────
      _recipe(
        name: 'Grilled Chicken & Quinoa Bowl',
        desc: 'Complete protein meal with complex carbs and healthy fats.',
        category: 'lunch',
        prep: 10, cook: 25, servings: 2,
        cal: 520, protein: 48, carbs: 44, fat: 14,
        ingredients: [
          _ing('Chicken breast', 300, 'g'),
          _ing('Quinoa (dry)', 120, 'g'),
          _ing('Avocado', 1, 'unit'),
          _ing('Cherry tomatoes', 100, 'g'),
          _ing('Cucumber', 100, 'g'),
          _ing('Lemon juice', 30, 'ml'),
          _ing('Olive oil', 15, 'ml'),
          _ing('Garlic powder', 1, 'tsp'),
          _ing('Salt & pepper', 1, 'pinch'),
        ],
        instructions: [
          'Cook quinoa: rinse, then simmer in 240ml water for 15 min.',
          'Season chicken with garlic powder, salt, and pepper.',
          'Grill chicken on medium-high heat, 6 min each side.',
          'Rest chicken 5 minutes then slice.',
          'Dice avocado, halve tomatoes, slice cucumber.',
          'Assemble bowls: quinoa base, chicken, then toppings.',
          'Drizzle olive oil and lemon juice to serve.',
        ],
        tags: ['high-protein', 'meal-prep', 'muscle-gain'],
      ),

      _recipe(
        name: 'Tuna & Chickpea Salad',
        desc: 'No-cook lunch packed with lean protein and fibre.',
        category: 'lunch',
        prep: 8, cook: 0, servings: 1,
        cal: 390, protein: 38, carbs: 32, fat: 10,
        ingredients: [
          _ing('Canned tuna in water', 160, 'g'),
          _ing('Chickpeas (canned, drained)', 120, 'g'),
          _ing('Red onion', 40, 'g'),
          _ing('Celery', 60, 'g'),
          _ing('Greek yogurt', 30, 'g'),
          _ing('Dijon mustard', 10, 'g'),
          _ing('Lemon juice', 15, 'ml'),
          _ing('Mixed salad leaves', 60, 'g'),
          _ing('Salt & pepper', 1, 'pinch'),
        ],
        instructions: [
          'Drain and flake tuna into a large bowl.',
          'Finely dice red onion and slice celery.',
          'Mix Greek yogurt, mustard, and lemon juice as dressing.',
          'Combine tuna, chickpeas, onion, and celery.',
          'Pour dressing over and toss well.',
          'Serve over mixed salad leaves.',
        ],
        tags: ['high-protein', 'quick', 'no-cook', 'low-calorie'],
      ),

      _recipe(
        name: 'Sweet Potato & Black Bean Burrito Bowl',
        desc: 'Plant-based powerhouse — high fibre, complex carbs.',
        category: 'lunch',
        prep: 10, cook: 30, servings: 2,
        cal: 480, protein: 18, carbs: 78, fat: 11,
        ingredients: [
          _ing('Sweet potato', 300, 'g'),
          _ing('Black beans (canned, drained)', 240, 'g'),
          _ing('Brown rice (dry)', 100, 'g'),
          _ing('Red pepper', 100, 'g'),
          _ing('Corn (canned)', 80, 'g'),
          _ing('Lime juice', 20, 'ml'),
          _ing('Cumin', 1, 'tsp'),
          _ing('Smoked paprika', 1, 'tsp'),
          _ing('Olive oil', 10, 'ml'),
          _ing('Coriander', 10, 'g'),
        ],
        instructions: [
          'Cook brown rice per packet instructions (~25 min).',
          'Cube sweet potato, toss with oil, cumin, paprika.',
          'Roast sweet potato at 200°C for 25 minutes.',
          'Sauté red pepper and corn in a pan 5 minutes.',
          'Warm black beans with remaining spices.',
          'Assemble bowls: rice, beans, sweet potato, peppers.',
          'Squeeze lime and garnish with coriander.',
        ],
        tags: ['vegan', 'high-fibre', 'meal-prep'],
      ),

      // ── DINNER ─────────────────────────
      _recipe(
        name: 'Salmon with Roasted Vegetables',
        desc: 'Omega-3 rich dinner — anti-inflammatory and muscle-building.',
        category: 'dinner',
        prep: 10, cook: 22, servings: 2,
        cal: 560, protein: 46, carbs: 28, fat: 28,
        ingredients: [
          _ing('Salmon fillets', 360, 'g'),
          _ing('Broccoli', 200, 'g'),
          _ing('Asparagus', 150, 'g'),
          _ing('Cherry tomatoes', 120, 'g'),
          _ing('Olive oil', 20, 'ml'),
          _ing('Lemon', 1, 'unit'),
          _ing('Garlic cloves', 3, 'unit'),
          _ing('Dill (fresh or dried)', 5, 'g'),
          _ing('Salt & pepper', 1, 'pinch'),
        ],
        instructions: [
          'Preheat oven to 200°C / 400°F.',
          'Cut broccoli into florets, snap tough ends off asparagus.',
          'Toss vegetables in olive oil, salt, and minced garlic.',
          'Spread on baking tray; roast 10 minutes.',
          'Place salmon on tray with vegetables.',
          'Squeeze lemon over salmon, top with dill.',
          'Roast further 12 minutes until salmon flakes easily.',
        ],
        tags: ['high-protein', 'omega-3', 'gluten-free', 'low-carb'],
      ),

      _recipe(
        name: 'Beef & Broccoli Stir Fry',
        desc: 'High-protein stir fry — faster than takeaway.',
        category: 'dinner',
        prep: 10, cook: 15, servings: 2,
        cal: 490, protein: 42, carbs: 30, fat: 18,
        ingredients: [
          _ing('Lean beef sirloin', 320, 'g'),
          _ing('Broccoli', 300, 'g'),
          _ing('Soy sauce (low sodium)', 45, 'ml'),
          _ing('Oyster sauce', 20, 'ml'),
          _ing('Garlic cloves', 3, 'unit'),
          _ing('Ginger (fresh)', 10, 'g'),
          _ing('Sesame oil', 10, 'ml'),
          _ing('Cornstarch', 10, 'g'),
          _ing('Beef stock', 60, 'ml'),
          _ing('Brown rice (cooked)', 200, 'g'),
        ],
        instructions: [
          'Slice beef thinly against the grain.',
          'Mix soy sauce, oyster sauce, stock, and cornstarch for sauce.',
          'Blanch broccoli in boiling water 2 minutes; drain.',
          'Heat sesame oil in wok on high heat.',
          'Stir fry beef 2–3 minutes until browned; remove.',
          'Add garlic and ginger; fry 30 seconds.',
          'Add broccoli and toss well.',
          'Return beef, pour over sauce; cook 2 minutes until glossy.',
          'Serve over brown rice.',
        ],
        tags: ['high-protein', 'muscle-gain', 'quick'],
      ),

      _recipe(
        name: 'Turkey Meatball & Courgette Pasta',
        desc: 'High-protein pasta with hidden vegetables.',
        category: 'dinner',
        prep: 15, cook: 25, servings: 3,
        cal: 510, protein: 44, carbs: 48, fat: 14,
        ingredients: [
          _ing('Lean turkey mince', 400, 'g'),
          _ing('Wholegrain pasta', 180, 'g'),
          _ing('Courgette', 200, 'g'),
          _ing('Passata', 400, 'g'),
          _ing('Egg', 1, 'unit'),
          _ing('Parmesan (grated)', 30, 'g'),
          _ing('Garlic cloves', 3, 'unit'),
          _ing('Dried oregano', 1, 'tsp'),
          _ing('Dried basil', 1, 'tsp'),
          _ing('Olive oil', 10, 'ml'),
        ],
        instructions: [
          'Mix turkey mince, egg, half the parmesan, oregano, salt.',
          'Roll into 18–20 small meatballs.',
          'Brown meatballs in olive oil, 3 min each side.',
          'Spiralize or ribbon the courgette.',
          'Sauté garlic 30 seconds, add passata and basil.',
          'Simmer sauce and meatballs together 15 minutes.',
          'Cook pasta per packet; add courgette last 2 minutes.',
          'Serve pasta topped with meatballs and remaining parmesan.',
        ],
        tags: ['high-protein', 'muscle-gain', 'meal-prep'],
      ),

      // ── SNACKS ─────────────────────────
      _recipe(
        name: 'Peanut Butter Protein Balls',
        desc: 'No-bake high-protein snack — make a batch, fridge for a week.',
        category: 'snack',
        prep: 10, cook: 0, servings: 4,
        cal: 220, protein: 12, carbs: 22, fat: 10,
        ingredients: [
          _ing('Rolled oats', 100, 'g'),
          _ing('Natural peanut butter', 60, 'g'),
          _ing('Protein powder (chocolate)', 40, 'g'),
          _ing('Honey', 30, 'g'),
          _ing('Dark chocolate chips', 30, 'g'),
          _ing('Chia seeds', 15, 'g'),
        ],
        instructions: [
          'Mix oats, protein powder, and chia seeds in a bowl.',
          'Add peanut butter and honey; mix until it clumps.',
          'Fold in chocolate chips.',
          'Refrigerate mixture 20 minutes to firm up.',
          'Roll into 12 equal balls.',
          'Store in fridge up to 7 days.',
        ],
        tags: ['high-protein', 'meal-prep', 'no-cook', 'quick'],
      ),

      _recipe(
        name: 'Apple & Almond Butter',
        desc: 'Clean snack — fibre, healthy fat, natural sugar.',
        category: 'snack',
        prep: 2, cook: 0, servings: 1,
        cal: 210, protein: 5, carbs: 28, fat: 10,
        ingredients: [
          _ing('Apple (medium)', 1, 'unit'),
          _ing('Almond butter', 30, 'g'),
          _ing('Cinnamon', 1, 'pinch'),
        ],
        instructions: [
          'Slice apple into wedges.',
          'Portion almond butter into a dipping bowl.',
          'Sprinkle cinnamon over almond butter.',
          'Dip and enjoy!',
        ],
        tags: ['vegan', 'quick', 'no-cook', 'low-calorie'],
      ),
    ];
  }

  // ── Built-in Meal Plan Templates ──────────────────────────

  List<MealPlan> _buildMealPlans(List<Recipe> recipes) {
    // Helper: get IDs of recipes matching a category
    List<String> idsFor(String category) => recipes
        .where((r) => r.category == category)
        .map((r) => r.id.toString())
        .toList();

    final allIds = recipes.map((r) => r.id.toString()).toList();

    return [
      MealPlan()
        ..name               = 'Muscle Gain Plan'
        ..description        = '7-day high-protein plan targeting 2,800+ kcal/day. '
            'Ideal for those in a caloric surplus wanting to build lean muscle.'
        ..goal               = 'muscle_gain'
        ..dailyCalorieTarget = 2800
        ..durationDays       = 7
        ..recipeIds          = allIds
        ..createdAt          = DateTime.now()
        ..isActive           = false,

      MealPlan()
        ..name               = 'Fat Loss Plan'
        ..description        = '7-day calorie-controlled plan at 1,600 kcal/day. '
            'High protein to preserve muscle while in a deficit.'
        ..goal               = 'weight_loss'
        ..dailyCalorieTarget = 1600
        ..durationDays       = 7
        ..recipeIds          = [
          ...idsFor('breakfast'),
          ...idsFor('snack'),
        ]
        ..createdAt          = DateTime.now()
        ..isActive           = false,

      MealPlan()
        ..name               = 'Balanced Maintenance'
        ..description        = '14-day balanced plan at 2,100 kcal/day for '
            'active people maintaining their current weight.'
        ..goal               = 'maintenance'
        ..dailyCalorieTarget = 2100
        ..durationDays       = 14
        ..recipeIds          = allIds
        ..createdAt          = DateTime.now()
        ..isActive           = false,

      MealPlan()
        ..name               = 'Vegan Performance'
        ..description        = '7-day plant-based plan with complete proteins. '
            'Approximately 2,000 kcal, all whole-food plant sources.'
        ..goal               = 'maintenance'
        ..dailyCalorieTarget = 2000
        ..durationDays       = 7
        ..recipeIds          = recipes
            .where((r) => r.tags.contains('vegan'))
            .map((r) => r.id.toString())
            .toList()
        ..createdAt          = DateTime.now()
        ..isActive           = false,
    ];
  }

  // ── Helpers ───────────────────────────────────────────────

  Recipe _recipe({
    required String name,
    required String desc,
    required String category,
    required int prep,
    required int cook,
    required int servings,
    required double cal,
    required double protein,
    required double carbs,
    required double fat,
    required List<RecipeIngredient> ingredients,
    required List<String> instructions,
    required List<String> tags,
  }) {
    return Recipe()

      ..name               = name
      ..description        = desc
      ..category           = category
      ..prepMinutes        = prep
      ..cookMinutes        = cook
      ..servings           = servings
      ..caloriesPerServing = cal
      ..proteinG           = protein
      ..carbsG             = carbs
      ..fatG               = fat
      ..ingredients        = ingredients
      ..instructions       = instructions
      ..tags               = tags;
  }

  RecipeIngredient _ing(String name, double amount, String unit) {
    return RecipeIngredient()
      ..name   = name
      ..amount = amount
      ..unit   = unit;
  }
}