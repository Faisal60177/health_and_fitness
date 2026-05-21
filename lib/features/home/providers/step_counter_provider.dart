import 'package:riverpod_annotation/riverpod_annotation.dart';

// This line is required — it tells build_runner to look at this file
// and generate 'step_counter_provider.g.dart' with the boilerplate
part 'step_counter_provider.g.dart';

// @riverpod annotation = "generate a provider for this class"
// The class extends a generated base class _$StepCounter
@riverpod
class StepCounter extends _$StepCounter {

  // build() defines the INITIAL STATE — runs once when first watched
  @override
  int build() => 0;

  // Methods on the class = actions you can call to change state
  void increment() => state++;

  void reset() => state = 0;

  void setSteps(int steps) => state = steps;
}