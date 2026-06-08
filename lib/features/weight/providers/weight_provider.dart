import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/weight_log.dart';
import '../../../data/repositories/weight_repository.dart';

part 'weight_provider.g.dart';

@riverpod
class WeightNotifier extends _$WeightNotifier {
  final _repo = WeightRepository();

  @override
  Future<List<WeightLog>> build() async {
    return _repo.getHistory();
  }

  Future<void> logWeight(double kg, {String notes = ''}) async {
    await _repo.logWeight(kg, notes: notes);
    ref.invalidateSelf();
    await future;
  }
}

// Separate provider for the latest weight — used in home dashboard
@riverpod
Future<WeightLog?> latestWeight(Ref ref) async {
  return WeightRepository().getLatest();
}





