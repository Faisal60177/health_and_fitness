import '../models/local_exercise.dart';

class LocalExerciseService {
  // All categories shown in filter chips
  static const List<String> categories = [
    'Chest',
    'Back',
    'Shoulders',
    'Arms',
    'Legs',
    'Core',
    'Cardio',
    'Full Body',
  ];

  // Search + filter — pure in-memory, instant
  static List<LocalExercise> getExercises({
    String? category,
    String searchTerm = '',
  }) {
    var list = _all;

    if (category != null && category.isNotEmpty) {
      list = list.where((e) => e.category == category).toList();
    }

    if (searchTerm.isNotEmpty) {
      final q = searchTerm.toLowerCase();
      list = list
          .where((e) =>
      e.name.toLowerCase().contains(q) ||
          e.category.toLowerCase().contains(q) ||
          e.muscles.any((m) => m.toLowerCase().contains(q)))
          .toList();
    }

    return list;
  }

  static LocalExercise? getById(String id) {
    try {
      return _all.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  // ── Exercise library ──────────────────────────────────────────────────────

  static const List<LocalExercise> _all = [
    // ── CHEST ──────────────────────────────────────────────────────────────
    LocalExercise(
      id: 'chest_01',
      name: 'Barbell Bench Press',
      category: 'Chest',
      equipment: 'Barbell',
      muscles: ['Pectoralis Major'],
      musclesSecondary: ['Triceps', 'Anterior Deltoid'],
      description:
      'Lie flat on bench. Grip bar slightly wider than shoulders. '
          'Lower bar to mid-chest with control. '
          'Press up explosively until arms are fully extended. '
          'Keep feet flat on floor and back slightly arched.',
    ),
    LocalExercise(
      id: 'chest_02',
      name: 'Incline Dumbbell Press',
      category: 'Chest',
      equipment: 'Dumbbell',
      muscles: ['Upper Pectoralis'],
      musclesSecondary: ['Triceps', 'Anterior Deltoid'],
      description:
      'Set bench to 30–45 degrees. '
          'Hold dumbbells at chest level with palms facing forward. '
          'Press up and slightly inward until arms are extended. '
          'Lower slowly back to start.',
    ),
    LocalExercise(
      id: 'chest_03',
      name: 'Push-Up',
      category: 'Chest',
      equipment: 'Bodyweight',
      muscles: ['Pectoralis Major'],
      musclesSecondary: ['Triceps', 'Core'],
      description:
      'Start in high plank with hands shoulder-width apart. '
          'Lower chest to just above floor, keeping elbows at 45 degrees. '
          'Push back up to full arm extension. '
          'Keep core tight throughout.',
    ),
    LocalExercise(
      id: 'chest_04',
      name: 'Cable Fly',
      category: 'Chest',
      equipment: 'Cable Machine',
      muscles: ['Pectoralis Major'],
      musclesSecondary: ['Anterior Deltoid'],
      description:
      'Stand between cable towers with handles set at shoulder height. '
          'With a slight bend in elbows, bring hands together in front of chest. '
          'Slowly return to start position with control.',
    ),
    LocalExercise(
      id: 'chest_05',
      name: 'Dumbbell Flye',
      category: 'Chest',
      equipment: 'Dumbbell',
      muscles: ['Pectoralis Major'],
      musclesSecondary: ['Anterior Deltoid'],
      description:
      'Lie flat on bench holding dumbbells above chest. '
          'With slight elbow bend, lower arms wide to sides. '
          'Feel stretch in chest, then bring arms back together.',
    ),

    // ── BACK ───────────────────────────────────────────────────────────────
    LocalExercise(
      id: 'back_01',
      name: 'Deadlift',
      category: 'Back',
      equipment: 'Barbell',
      muscles: ['Erector Spinae', 'Latissimus Dorsi'],
      musclesSecondary: ['Glutes', 'Hamstrings', 'Traps'],
      description:
      'Stand with bar over mid-foot, hip-width stance. '
          'Hinge at hips, grip bar just outside legs. '
          'Keep chest up and back flat. '
          'Drive through floor to stand up, hips and shoulders rise together. '
          'Lower bar with control.',
    ),
    LocalExercise(
      id: 'back_02',
      name: 'Pull-Up',
      category: 'Back',
      equipment: 'Pull-Up Bar',
      muscles: ['Latissimus Dorsi'],
      musclesSecondary: ['Biceps', 'Rear Deltoid'],
      description:
      'Hang from bar with overhand grip, slightly wider than shoulders. '
          'Engage lats and pull chest to bar. '
          'Lower slowly to full hang. '
          'Avoid swinging or kipping.',
    ),
    LocalExercise(
      id: 'back_03',
      name: 'Barbell Row',
      category: 'Back',
      equipment: 'Barbell',
      muscles: ['Latissimus Dorsi', 'Rhomboids'],
      musclesSecondary: ['Biceps', 'Rear Deltoid'],
      description:
      'Hinge forward to about 45 degrees with flat back. '
          'Pull bar to lower chest/upper abdomen. '
          'Squeeze shoulder blades at top. '
          'Lower with control.',
    ),
    LocalExercise(
      id: 'back_04',
      name: 'Lat Pulldown',
      category: 'Back',
      equipment: 'Cable Machine',
      muscles: ['Latissimus Dorsi'],
      musclesSecondary: ['Biceps', 'Rear Deltoid'],
      description:
      'Sit at pulldown machine, grip bar wide. '
          'Pull bar to upper chest, driving elbows toward hips. '
          'Lean back slightly at bottom. '
          'Return bar slowly.',
    ),
    LocalExercise(
      id: 'back_05',
      name: 'Seated Cable Row',
      category: 'Back',
      equipment: 'Cable Machine',
      muscles: ['Rhomboids', 'Latissimus Dorsi'],
      musclesSecondary: ['Biceps', 'Erector Spinae'],
      description:
      'Sit upright at cable row station. '
          'Pull handle to abdomen, driving elbows back. '
          'Squeeze shoulder blades together at peak. '
          'Extend arms fully to return.',
    ),
    LocalExercise(
      id: 'back_06',
      name: 'Romanian Deadlift',
      category: 'Back',
      equipment: 'Barbell',
      muscles: ['Hamstrings', 'Glutes'],
      musclesSecondary: ['Erector Spinae'],
      description:
      'Stand holding bar at hip height. '
          'Hinge at hips, keeping bar close to legs. '
          'Lower until you feel hamstring stretch. '
          'Drive hips forward to return.',
    ),

    // ── SHOULDERS ──────────────────────────────────────────────────────────
    LocalExercise(
      id: 'shoulders_01',
      name: 'Overhead Press',
      category: 'Shoulders',
      equipment: 'Barbell',
      muscles: ['Anterior Deltoid', 'Medial Deltoid'],
      musclesSecondary: ['Triceps', 'Upper Traps'],
      description:
      'Stand holding bar at collarbone height. '
          'Press bar straight up overhead until arms lock out. '
          'Lower back to collarbone with control. '
          'Keep core braced, avoid hyperextending lower back.',
    ),
    LocalExercise(
      id: 'shoulders_02',
      name: 'Dumbbell Shoulder Press',
      category: 'Shoulders',
      equipment: 'Dumbbell',
      muscles: ['Anterior Deltoid', 'Medial Deltoid'],
      musclesSecondary: ['Triceps'],
      description:
      'Sit or stand holding dumbbells at ear level. '
          'Press up until arms are extended overhead. '
          'Lower slowly back to ears.',
    ),
    LocalExercise(
      id: 'shoulders_03',
      name: 'Lateral Raise',
      category: 'Shoulders',
      equipment: 'Dumbbell',
      muscles: ['Medial Deltoid'],
      musclesSecondary: ['Upper Traps'],
      description:
      'Stand holding light dumbbells at sides. '
          'Raise arms out to sides to shoulder height. '
          'Keep slight bend in elbows. '
          'Lower slowly — avoid using momentum.',
    ),
    LocalExercise(
      id: 'shoulders_04',
      name: 'Face Pull',
      category: 'Shoulders',
      equipment: 'Cable Machine',
      muscles: ['Rear Deltoid', 'Rotator Cuff'],
      musclesSecondary: ['Rhomboids', 'Traps'],
      description:
      'Set cable at face height with rope attachment. '
          'Pull rope toward face, flaring elbows out. '
          'Externally rotate at end of movement. '
          'Return with control.',
    ),
    LocalExercise(
      id: 'shoulders_05',
      name: 'Arnold Press',
      category: 'Shoulders',
      equipment: 'Dumbbell',
      muscles: ['Anterior Deltoid', 'Medial Deltoid'],
      musclesSecondary: ['Rear Deltoid', 'Triceps'],
      description:
      'Start with dumbbells at chin height, palms facing you. '
          'As you press up, rotate palms to face forward. '
          'Reverse on the way down.',
    ),

    // ── ARMS ───────────────────────────────────────────────────────────────
    LocalExercise(
      id: 'arms_01',
      name: 'Barbell Bicep Curl',
      category: 'Arms',
      equipment: 'Barbell',
      muscles: ['Biceps Brachii'],
      musclesSecondary: ['Brachialis', 'Forearms'],
      description:
      'Stand holding bar with underhand grip, shoulder-width. '
          'Curl bar to shoulder height, keeping elbows at sides. '
          'Lower slowly — full range of motion.',
    ),
    LocalExercise(
      id: 'arms_02',
      name: 'Hammer Curl',
      category: 'Arms',
      equipment: 'Dumbbell',
      muscles: ['Brachialis', 'Biceps Brachii'],
      musclesSecondary: ['Forearms'],
      description:
      'Hold dumbbells with neutral grip (palms facing each other). '
          'Curl to shoulder height keeping wrists neutral. '
          'Lower with control.',
    ),
    LocalExercise(
      id: 'arms_03',
      name: 'Tricep Dip',
      category: 'Arms',
      equipment: 'Bodyweight',
      muscles: ['Triceps Brachii'],
      musclesSecondary: ['Anterior Deltoid', 'Chest'],
      description:
      'Grip parallel bars with arms straight. '
          'Lower body by bending elbows to 90 degrees. '
          'Press back up to start. '
          'Lean forward slightly to target triceps more.',
    ),
    LocalExercise(
      id: 'arms_04',
      name: 'Tricep Pushdown',
      category: 'Arms',
      equipment: 'Cable Machine',
      muscles: ['Triceps Brachii'],
      description:
      'Stand at cable machine with bar at chest height. '
          'Keep elbows at sides throughout. '
          'Push bar down until arms are fully extended. '
          'Return slowly.',
    ),
    LocalExercise(
      id: 'arms_05',
      name: 'Skull Crusher',
      category: 'Arms',
      equipment: 'Barbell',
      muscles: ['Triceps Brachii'],
      description:
      'Lie on bench holding bar above chest, arms extended. '
          'Bend elbows to lower bar toward forehead. '
          'Extend arms back to start.',
    ),
    LocalExercise(
      id: 'arms_06',
      name: 'Preacher Curl',
      category: 'Arms',
      equipment: 'Barbell',
      muscles: ['Biceps Brachii'],
      musclesSecondary: ['Brachialis'],
      description:
      'Rest upper arms on preacher pad. '
          'Curl bar to shoulder height. '
          'Lower slowly — do not fully lock out at bottom.',
    ),

    // ── LEGS ───────────────────────────────────────────────────────────────
    LocalExercise(
      id: 'legs_01',
      name: 'Barbell Squat',
      category: 'Legs',
      equipment: 'Barbell',
      muscles: ['Quadriceps', 'Glutes'],
      musclesSecondary: ['Hamstrings', 'Erector Spinae', 'Core'],
      description:
      'Bar on upper traps, feet shoulder-width. '
          'Break at hips and knees simultaneously. '
          'Descend until thighs are parallel to floor. '
          'Drive through heels to stand. '
          'Keep knees tracking over toes.',
    ),
    LocalExercise(
      id: 'legs_02',
      name: 'Leg Press',
      category: 'Legs',
      equipment: 'Machine',
      muscles: ['Quadriceps', 'Glutes'],
      musclesSecondary: ['Hamstrings'],
      description:
      'Sit in leg press machine with feet shoulder-width on platform. '
          'Lower platform until knees reach 90 degrees. '
          'Press back up without locking out knees fully.',
    ),
    LocalExercise(
      id: 'legs_03',
      name: 'Bulgarian Split Squat',
      category: 'Legs',
      equipment: 'Dumbbell',
      muscles: ['Quadriceps', 'Glutes'],
      musclesSecondary: ['Hamstrings', 'Core'],
      description:
      'Rear foot elevated on bench, front foot forward. '
          'Lower back knee toward floor. '
          'Keep front shin vertical. '
          'Drive through front heel to rise.',
    ),
    LocalExercise(
      id: 'legs_04',
      name: 'Leg Curl',
      category: 'Legs',
      equipment: 'Machine',
      muscles: ['Hamstrings'],
      description:
      'Lie face down on leg curl machine. '
          'Curl legs up toward glutes. '
          'Lower slowly — do not let weight stack drop.',
    ),
    LocalExercise(
      id: 'legs_05',
      name: 'Calf Raise',
      category: 'Legs',
      equipment: 'Bodyweight',
      muscles: ['Gastrocnemius', 'Soleus'],
      description:
      'Stand on edge of step with heels hanging off. '
          'Rise onto toes as high as possible. '
          'Lower heels below step level for full stretch. '
          'Pause at top.',
    ),
    LocalExercise(
      id: 'legs_06',
      name: 'Lunge',
      category: 'Legs',
      equipment: 'Bodyweight',
      muscles: ['Quadriceps', 'Glutes'],
      musclesSecondary: ['Hamstrings', 'Core'],
      description:
      'Step forward with one leg. '
          'Lower back knee toward floor. '
          'Front knee stays over ankle. '
          'Push back to start and alternate legs.',
    ),

    // ── CORE ───────────────────────────────────────────────────────────────
    LocalExercise(
      id: 'core_01',
      name: 'Plank',
      category: 'Core',
      equipment: 'Bodyweight',
      muscles: ['Rectus Abdominis', 'Transverse Abdominis'],
      musclesSecondary: ['Obliques', 'Glutes'],
      description:
      'Forearms and toes on floor, body in straight line. '
          'Brace core and squeeze glutes. '
          'Hold — do not let hips sag or rise.',
    ),
    LocalExercise(
      id: 'core_02',
      name: 'Crunch',
      category: 'Core',
      equipment: 'Bodyweight',
      muscles: ['Rectus Abdominis'],
      description:
      'Lie on back, knees bent, feet flat. '
          'Hands behind head or on chest. '
          'Curl shoulders off floor, exhale at top. '
          'Lower with control — do not pull neck.',
    ),
    LocalExercise(
      id: 'core_03',
      name: 'Hanging Leg Raise',
      category: 'Core',
      equipment: 'Pull-Up Bar',
      muscles: ['Lower Rectus Abdominis', 'Hip Flexors'],
      description:
      'Hang from bar with straight arms. '
          'Raise legs to 90 degrees (or higher). '
          'Lower slowly — avoid swinging.',
    ),
    LocalExercise(
      id: 'core_04',
      name: 'Russian Twist',
      category: 'Core',
      equipment: 'Bodyweight',
      muscles: ['Obliques'],
      musclesSecondary: ['Rectus Abdominis'],
      description:
      'Sit on floor, lean back slightly, feet raised. '
          'Rotate torso side to side. '
          'Add weight plate or medicine ball for difficulty.',
    ),
    LocalExercise(
      id: 'core_05',
      name: 'Mountain Climber',
      category: 'Core',
      equipment: 'Bodyweight',
      muscles: ['Core', 'Hip Flexors'],
      musclesSecondary: ['Shoulders', 'Chest'],
      description:
      'Start in push-up position. '
          'Alternate driving knees to chest rapidly. '
          'Keep hips level and core tight.',
    ),
    LocalExercise(
      id: 'core_06',
      name: 'Ab Wheel Rollout',
      category: 'Core',
      equipment: 'Ab Wheel',
      muscles: ['Rectus Abdominis', 'Transverse Abdominis'],
      musclesSecondary: ['Lats', 'Shoulders'],
      description:
      'Kneel and hold ab wheel with both hands. '
          'Roll forward as far as you can while keeping back flat. '
          'Contract abs to roll back to start.',
    ),

    // ── CARDIO ─────────────────────────────────────────────────────────────
    LocalExercise(
      id: 'cardio_01',
      name: 'Burpee',
      category: 'Cardio',
      equipment: 'Bodyweight',
      muscles: ['Full Body'],
      description:
      'From standing, drop hands to floor. '
          'Jump feet back to push-up position. '
          'Perform a push-up. '
          'Jump feet forward, then explode up with a jump.',
    ),
    LocalExercise(
      id: 'cardio_02',
      name: 'Jump Rope',
      category: 'Cardio',
      equipment: 'Jump Rope',
      muscles: ['Calves', 'Core'],
      musclesSecondary: ['Shoulders', 'Forearms'],
      description:
      'Hold handles at hip height, swing rope overhead. '
          'Jump with both feet as rope passes under. '
          'Land softly on balls of feet. '
          'Maintain consistent rhythm.',
    ),
    LocalExercise(
      id: 'cardio_03',
      name: 'Box Jump',
      category: 'Cardio',
      equipment: 'Box',
      muscles: ['Quadriceps', 'Glutes', 'Calves'],
      description:
      'Stand in front of box, feet shoulder-width. '
          'Swing arms, bend knees and explode up onto box. '
          'Land softly with both feet, stand tall. '
          'Step down carefully.',
    ),
    LocalExercise(
      id: 'cardio_04',
      name: 'High Knees',
      category: 'Cardio',
      equipment: 'Bodyweight',
      muscles: ['Hip Flexors', 'Core'],
      musclesSecondary: ['Calves', 'Quadriceps'],
      description:
      'Run in place driving knees to waist height. '
          'Pump arms in opposition to legs. '
          'Stay on balls of feet. '
          'Maintain upright posture.',
    ),

    // ── FULL BODY ──────────────────────────────────────────────────────────
    LocalExercise(
      id: 'fullbody_01',
      name: 'Thruster',
      category: 'Full Body',
      equipment: 'Barbell',
      muscles: ['Quadriceps', 'Shoulders', 'Glutes'],
      musclesSecondary: ['Triceps', 'Core'],
      description:
      'Hold bar at shoulder height. '
          'Squat down, then explosively stand and press bar overhead. '
          'Lower bar back to shoulders as you descend into next squat.',
    ),
    LocalExercise(
      id: 'fullbody_02',
      name: 'Kettlebell Swing',
      category: 'Full Body',
      equipment: 'Kettlebell',
      muscles: ['Glutes', 'Hamstrings'],
      musclesSecondary: ['Core', 'Shoulders'],
      description:
      'Hinge at hips holding kettlebell with both hands. '
          'Drive hips forward explosively to swing bell to shoulder height. '
          'Hinge back as bell swings down. '
          'Power comes from hips, not arms.',
    ),
    LocalExercise(
      id: 'fullbody_03',
      name: 'Clean and Press',
      category: 'Full Body',
      equipment: 'Barbell',
      muscles: ['Full Body'],
      description:
      'Pull bar from floor in one explosive motion to shoulders. '
          'Catch in front rack position. '
          'Press bar overhead. '
          'Lower back to floor with control.',
    ),
  ];
}



