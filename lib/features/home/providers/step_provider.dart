import 'dart:async';
import 'package:health/health.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/user_goals.dart';
import '../../../data/repositories/step_repository.dart';
import '../../../data/repositories/user_goals_repository.dart';
import 'package:health_and_fitness/data/services/notification_service.dart';

part 'step_provider.g.dart';

class StepState {
  final int    todaySteps;
  final int    dailyGoal;
  final bool   sensorAvailable;
  final String? errorMessage;
  final int    slowSteps;
  final int    briskSteps;
  final double distanceKm;
  final double caloriesBurned;
  final double strideLengthM;

  const StepState({
    this.todaySteps      = 0,
    this.dailyGoal       = 10000,
    this.sensorAvailable = false,
    this.errorMessage,
    this.slowSteps       = 0,
    this.briskSteps      = 0,
    this.distanceKm      = 0,
    this.caloriesBurned  = 0,
    this.strideLengthM   = 0.75,
  });

  double get progressPercent =>
      (todaySteps / dailyGoal).clamp(0.0, 1.0);

  // Pace percentages for slow/brisk split bar (Image 1)
  double get slowPercent =>
      todaySteps > 0 ? (slowSteps / todaySteps).clamp(0.0, 1.0) : 0;
  double get briskPercent =>
      todaySteps > 0 ? (briskSteps / todaySteps).clamp(0.0, 1.0) : 0;

  StepState copyWith({
    int?    todaySteps,
    int?    dailyGoal,
    bool?   sensorAvailable,
    String? errorMessage,
    int?    slowSteps,
    int?    briskSteps,
    double? distanceKm,
    double? caloriesBurned,
    double? strideLengthM,
  }) {
    return StepState(
      todaySteps:      todaySteps      ?? this.todaySteps,
      dailyGoal:       dailyGoal       ?? this.dailyGoal,
      sensorAvailable: sensorAvailable ?? this.sensorAvailable,
      errorMessage:    errorMessage,
      slowSteps:       slowSteps       ?? this.slowSteps,
      briskSteps:      briskSteps      ?? this.briskSteps,
      distanceKm:      distanceKm      ?? this.distanceKm,
      caloriesBurned:  caloriesBurned  ?? this.caloriesBurned,
      strideLengthM:   strideLengthM   ?? this.strideLengthM,
    );
  }
}

@riverpod
class StepNotifier extends _$StepNotifier {
  final _repo      = StepRepository();
  final _goalsRepo = UserGoalsRepository();
  final _health    = Health();

  StreamSubscription<StepCount>? _pedometerSub;
  StreamSubscription<PedestrianStatus>? _statusSub;

  // Tracks walking speed for slow/brisk classification
  String _pedestrianStatus = 'stopped'; // 'walking', 'stopped'
  int _sessionSlowSteps  = 0;
  int _sessionBriskSteps = 0;

  // Pedometer base — raw sensor value at session start
  int _sensorBase     = -1;  // -1 means not yet set
  int _savedStepsBase = 0;   // steps already saved before this session

  @override
  StepState build() {
    ref.onDispose(() {
      _pedometerSub?.cancel();
      _statusSub?.cancel();
    });
    Future.microtask(_initialize);
    return const StepState();
  }

  Future<void> _initialize() async {
    // Load user's custom goal first
    final goals = await _goalsRepo.getGoals();

    // Load today's saved steps from Isar
    final todayEntry  = await _repo.getTodayEntry();
    final savedSteps  = todayEntry?.stepCount ?? 0;
    _savedStepsBase   = savedSteps;

    // Compute distance and calories from saved data
    final distance  = (savedSteps * goals.strideLengthM) / 1000;
    final calories  = savedSteps * 0.04;

    state = state.copyWith(
      todaySteps:     savedSteps,
      dailyGoal:      goals.dailyStepGoal,
      distanceKm:     distance,
      caloriesBurned: calories,
      strideLengthM:  goals.strideLengthM,
    );

    // Try Health Connect first — gives background step counts
    final healthSteps = await _getStepsFromHealthConnect();
    if (healthSteps > savedSteps) {
      // Health Connect has more recent data (counted while app was closed)
      await _repo.saveTodaySteps(healthSteps);
      state = state.copyWith(
        todaySteps:     healthSteps,
        distanceKm:     (healthSteps * goals.strideLengthM) / 1000,
        caloriesBurned: healthSteps * 0.04,
        sensorAvailable: true,
      );
      _savedStepsBase = healthSteps;
    }

    // Start live pedometer for real-time updates while app is open
    await _startPedometer();
  }

  // ── Health Connect — counts steps when app is CLOSED ────────────
  // This is the key for background step counting
  Future<int> _getStepsFromHealthConnect() async {
    try {
      await _health.configure();

      final granted = await _health.requestAuthorization([
        HealthDataType.STEPS,
        HealthDataType.WALKING_SPEED,
      ]);

      if (!granted) return 0;

      final now   = DateTime.now();
      final start = DateTime(now.year, now.month, now.day);

      // getTotalStepsInInterval reads from Health Connect
      // Health Connect aggregates steps from ALL sources:
      // - Phone hardware sensor (even when app is closed)
      // - Smartwatch / Fitbit / Garmin if connected
      // - Google Fit if enabled
      final steps = await _health.getTotalStepsInInterval(start, now);
      return steps ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // ── Live Pedometer — real-time counting while app is open ───────
  Future<void> _startPedometer() async {
    final status = await Permission.activityRecognition.request();
    if (!status.isGranted) {
      state = state.copyWith(
        errorMessage: 'Grant Activity Recognition permission for step tracking.',
        sensorAvailable: false,
      );
      return;
    }

    state = state.copyWith(sensorAvailable: true);

    // PedestrianStatus tells us if user is walking or stopped
    // Used to classify steps as slow (walking) or brisk (running)
    _statusSub = Pedometer.pedestrianStatusStream.listen(
          (event) {
        _pedestrianStatus = event.status; // 'walking' or 'stopped'
      },
      onError: (_) {},
    );

    // StepCountStream fires on every step
    _pedometerSub = Pedometer.stepCountStream.listen(
      _onStep,
      onError: (e) {
        state = state.copyWith(
          errorMessage: 'Step sensor error: $e',
          sensorAvailable: false,
        );
      },
    );
  }

  void _onStep(StepCount event) {
    final rawTotal = event.steps;

    // FIXED BASE LOGIC:
    // On first reading, record the raw sensor value as the base
    // Then delta = rawTotal - base = steps taken THIS SESSION only
    if (_sensorBase == -1) {
      _sensorBase = rawTotal;
    }

    final sessionSteps  = (rawTotal - _sensorBase).clamp(0, 999999);
    final totalToday    = _savedStepsBase + sessionSteps;

    // Classify this step as slow or brisk based on pedestrian status
    // In a real implementation you'd track step cadence (steps/min)
    // Simple approach: status 'walking' = normal pace
    // You could also use accelerometer data for more accuracy
    if (_pedestrianStatus == 'walking') {
      _sessionSlowSteps++;
    } else {
      _sessionBriskSteps++;
    }

    final distance  = (totalToday * state.strideLengthM) / 1000;
    final calories  = totalToday * 0.04;

    state = state.copyWith(
      todaySteps:     totalToday,
      slowSteps:      _sessionSlowSteps,
      briskSteps:     _sessionBriskSteps,
      distanceKm:     distance,
      caloriesBurned: calories,
    );

    // Save to Isar — async, doesn't block UI
    _repo.saveTodaySteps(totalToday);
    // Check if goal was just crossed — notify once per day
    if (totalToday >= state.dailyGoal &&
        totalToday - sessionSteps < state.dailyGoal) {
      // This condition means: just crossed the threshold this step
      NotificationService.notifyStepGoalReached(totalToday);
    }
  }

  // Called when user changes their daily goal from settings
  Future<void> updateDailyGoal(int newGoal) async {
    await _goalsRepo.updateDailyStepGoal(newGoal);
    state = state.copyWith(dailyGoal: newGoal);
  }

  // Manual test override for emulators
  void addTestSteps(int count) {
    final newSteps = state.todaySteps + count;
    final distance = (newSteps * state.strideLengthM) / 1000;
    state = state.copyWith(
      todaySteps:     newSteps,
      distanceKm:     distance,
      caloriesBurned: newSteps * 0.04,
    );
    _repo.saveTodaySteps(newSteps);
  }
}
