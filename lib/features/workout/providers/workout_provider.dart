import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/workout_log.dart';
import '../../../data/repositories/workout_repository.dart';

part 'workout_provider.g.dart';

// Provides the repository as a singleton
@riverpod
WorkoutRepository workoutRepository(Ref ref) {
  return WorkoutRepository();
}

// Manages the list of all workout sessions
// AsyncNotifier = Notifier that handles async operations with loading states
@riverpod
class WorkoutNotifier extends _$WorkoutNotifier {
  @override
  Future<List<WorkoutSession>> build() async {
    // Loads all sessions from Isar when first watched
    return ref.read(workoutRepositoryProvider).getAllSessions();
  }

  // Add a new workout session
  Future<void> addSession(WorkoutSession session) async {
    await ref.read(workoutRepositoryProvider).saveSession(session);
    // Refresh the list after saving
    ref.invalidateSelf();  // triggers build() to re-run
    await future;          // wait for the reload to complete
  }

  Future<void> deleteSession(int id) async {
    await ref.read(workoutRepositoryProvider).deleteSession(id);
    ref.invalidateSelf();
    await future;
  }
}

// Manages the workout being ACTIVELY BUILT (before saving)
// This is the in-progress session state — not yet in Isar
@riverpod
class ActiveWorkout extends _$ActiveWorkout {
  @override
  WorkoutSession? build() => null; // null = no active workout

  // Start a new workout session
  void start(String name) {
    state = WorkoutSession()
      ..name = name
      ..date = DateTime.now()
      ..durationMinutes = 0
      ..exercises = [];
  }

  // Add an exercise to the current session
  void addExercise(String name, String muscleGroup) {
    if (state == null) return;
    final exercise = WorkoutExercise(name: '', muscleGroup: '')
      ..name = name
      ..muscleGroup = muscleGroup
      ..sets = [];

    // Dart doesn't mutate state directly — create a new object
    // This ensures Riverpod detects the change and rebuilds watchers
    state = WorkoutSession()
      ..id = state!.id
      ..name = state!.name
      ..date = state!.date
      ..durationMinutes = state!.durationMinutes
      ..exercises = [...state!.exercises, exercise];
  }

  // Add a set to a specific exercise
  void addSet(int exerciseIndex, WorkoutSet set) {
    if (state == null) return;
    final exercises = List<WorkoutExercise>.from(state!.exercises);
    exercises[exerciseIndex].sets.add(set);
    state = WorkoutSession()
      ..id = state!.id
      ..name = state!.name
      ..date = state!.date
      ..durationMinutes = state!.durationMinutes
      ..exercises = exercises;
  }

  void clear() => state = null;
}






