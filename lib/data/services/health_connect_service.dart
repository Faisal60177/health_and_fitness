import 'package:health/health.dart';

class HealthConnectService {
  final _health = Health();

  // Data types we want to read from Health Connect / Google Fit
  static const _types = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.WEIGHT,
    HealthDataType.ACTIVE_ENERGY_BURNED,
  ];

  // Request permissions from the user
  // Returns true if all permissions granted
  Future<bool> requestPermissions() async {
    // Configure which health platform to use
    await _health.configure();

    final permissions = _types
        .map((_) => HealthDataAccess.READ_WRITE)
        .toList();

    try {
      final granted = await _health.requestAuthorization(
        _types,
        permissions: permissions,
      );
      return granted;
    } catch (e) {
      return false;
    }
  }

  // Read today's steps from Health Connect
  // This syncs with Google Fit, Samsung Health, Fitbit etc.
  Future<int> getTodaySteps() async {
    final now   = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);

    try {
      final steps = await _health.getTotalStepsInInterval(start, now);
      return steps ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Read last night's sleep
  Future<double> getLastSleepHours() async {
    final now   = DateTime.now();
    final start = now.subtract(const Duration(hours: 16));

    try {
      final data = await _health.getHealthDataFromTypes(
        types:     [HealthDataType.SLEEP_ASLEEP],
        startTime: start,
        endTime:   now,
      );

      final totalMinutes = data.fold<double>(
        0,
            (sum, point) {
          final diff = point.dateTo.difference(point.dateFrom);
          return sum + diff.inMinutes;
        },
      );

      return totalMinutes / 60;
    } catch (e) {
      return 0;
    }
  }

  // Read heart rate data for the last hour
  Future<double?> getLatestHeartRate() async {
    final now   = DateTime.now();
    final start = now.subtract(const Duration(hours: 1));

    try {
      final data = await _health.getHealthDataFromTypes(
        types:     [HealthDataType.HEART_RATE],
        startTime: start,
        endTime:   now,
      );

      if (data.isEmpty) return null;

      // Return the most recent reading
      data.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));
      return (data.first.value as NumericHealthValue).numericValue.toDouble();
    } catch (e) {
      return null;
    }
  }

  // Write steps back to Health Connect (for our pedometer data)
  Future<bool> writeSteps(int steps) async {
    final now   = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);

    try {
      return await _health.writeHealthData(
        value:     steps.toDouble(),
        type:      HealthDataType.STEPS,
        startTime: start,
        endTime:   now,
      );
    } catch (e) {
      return false;
    }
  }
}