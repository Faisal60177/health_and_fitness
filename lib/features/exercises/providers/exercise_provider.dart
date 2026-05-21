import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/exercise_cache.dart';
import '../../../data/repositories/exercise_repository.dart';

part 'exercise_provider.g.dart';

class ExerciseState {
  final List<ExerciseCache> exercises;
  final bool isLoading;
  final String searchTerm;
  final String? selectedCategory;
  final String? error;

  const ExerciseState({
    this.exercises       = const [],
    this.isLoading       = false,
    this.searchTerm      = '',
    this.selectedCategory,
    this.error,
  });

  ExerciseState copyWith({
    List<ExerciseCache>? exercises,
    bool?   isLoading,
    String? searchTerm,
    String? selectedCategory,
    String? error,
    bool clearCategory = false,
  }) {
    return ExerciseState(
      exercises:        exercises        ?? this.exercises,
      isLoading:        isLoading        ?? this.isLoading,
      searchTerm:       searchTerm       ?? this.searchTerm,
      selectedCategory: clearCategory
          ? null
          : selectedCategory ?? this.selectedCategory,
      error:            error,
    );
  }
}

@riverpod
class ExerciseNotifier extends _$ExerciseNotifier {
  final _repo = ExerciseRepository();

  @override
  ExerciseState build() {
    // Trigger first load after build completes
    // Using addPostFrameCallback avoids calling setState during build
    Future.delayed(Duration.zero, () => loadExercises());

    // Start in loading state — spinner shows immediately
    return const ExerciseState(isLoading: true);
  }

  Future<void> loadExercises({String? categoryId}) async {
    // Don't show loading spinner when switching categories if we have data
    final hadData = state.exercises.isNotEmpty;
    state = state.copyWith(
      isLoading:        !hadData,
      selectedCategory: categoryId,
      clearCategory:    categoryId == null,
      error:            null,
    );

    try {
      final exercises = await _repo.getExercises(
        categoryId: categoryId,
        searchTerm: state.searchTerm,
      );

      state = state.copyWith(
        exercises: exercises,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load exercises. Check your connection.',
      );
    }
  }

  Future<void> search(String query) async {
    state = state.copyWith(searchTerm: query);

    if (query.isEmpty) {
      await loadExercises(categoryId: state.selectedCategory);
      return;
    }

    // Debounce: only search when query is ≥2 chars
    if (query.length < 2) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final results = await _repo.search(query);
      state = state.copyWith(exercises: results, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Search failed');
    }
  }

  void clearSearch() {
    state = state.copyWith(searchTerm: '');
    loadExercises(categoryId: state.selectedCategory);
  }
}

@riverpod
Future<ExerciseCache?> exerciseDetail(ExerciseDetailRef ref, int apiId) async {
  return ExerciseRepository().getById(apiId);
}