import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/local_exercise.dart';
import '../../../data/services/local_exercise_service.dart';

part 'exercise_provider.g.dart';

class ExerciseState {
  final List<LocalExercise> exercises;
  final bool isLoading;
  final String searchTerm;
  final String? selectedCategory;
  final String? error;

  const ExerciseState({
    this.exercises        = const [],
    this.isLoading        = false,
    this.searchTerm       = '',
    this.selectedCategory,
    this.error,
  });

  ExerciseState copyWith({
    List<LocalExercise>? exercises,
    bool?   isLoading,
    String? searchTerm,
    String? selectedCategory,
    String? error,
    bool    clearCategory = false,
  }) {
    return ExerciseState(
      exercises:        exercises        ?? this.exercises,
      isLoading:        isLoading        ?? this.isLoading,
      searchTerm:       searchTerm       ?? this.searchTerm,
      selectedCategory: clearCategory
          ? null
          : selectedCategory ?? this.selectedCategory,
      error: error,
    );
  }
}

@riverpod
class ExerciseNotifier extends _$ExerciseNotifier {
  @override
  ExerciseState build() {
    // Synchronous — no async needed, data is local
    final exercises = LocalExerciseService.getExercises();
    return ExerciseState(exercises: exercises);
  }

  void loadExercises({String? category}) {
    state = state.copyWith(
      exercises:        LocalExerciseService.getExercises(
        category:   category,
        searchTerm: state.searchTerm,
      ),
      selectedCategory: category,
      clearCategory:    category == null,
      error:            null,
    );
  }

  void search(String query) {
    state = state.copyWith(searchTerm: query);
    state = state.copyWith(
      exercises: LocalExerciseService.getExercises(
        category:   state.selectedCategory,
        searchTerm: query,
      ),
    );
  }

  void clearSearch() {
    state = state.copyWith(searchTerm: '');
    loadExercises(category: state.selectedCategory);
  }
}



