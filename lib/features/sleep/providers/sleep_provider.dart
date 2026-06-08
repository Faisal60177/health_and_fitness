import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/sleep_log.dart';
import '../../../data/repositories/sleep_repository.dart';

part 'sleep_provider.g.dart';

@riverpod
class SleepNotifier extends _$SleepNotifier {
  final _repo = SleepRepository();

  @override
  Future<List<SleepLog>> build() async {
    return _repo.getRecentNights(30);
  }

  Future<void> logSleep({
    required DateTime bedTime,
    required DateTime wakeTime,
    required int quality,
    String notes = '',
  }) async {
    final log = SleepLog()
      ..date = wakeTime                // the day you woke is the date
      ..bedTime = bedTime
      ..wakeTime = wakeTime
      ..qualityRating = quality
      ..notes = notes;

    await _repo.logSleep(log);
    ref.invalidateSelf();
    await future;
  }

  Future<void> deleteLog(int id) async {
    await _repo.deleteLog(id);
    ref.invalidateSelf();
    await future;
  }
}



