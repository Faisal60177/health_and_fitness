class LocalExercise {
  final String id;
  final String name;
  final String description;
  final String category;       // 'Chest', 'Back', 'Legs', etc.
  final String equipment;      // 'Barbell', 'Dumbbell', 'Bodyweight', etc.
  final List<String> muscles;
  final List<String> musclesSecondary;
  // gifUrl intentionally empty — add later when API/images are ready
  final String gifUrl;

  const LocalExercise({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.equipment,
    required this.muscles,
    this.musclesSecondary = const [],
    this.gifUrl = '',
  });
}




