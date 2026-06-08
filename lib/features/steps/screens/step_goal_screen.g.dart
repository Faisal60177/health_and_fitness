// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_goal_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userGoals)
final userGoalsProvider = UserGoalsProvider._();

final class UserGoalsProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserGoals>,
          UserGoals,
          FutureOr<UserGoals>
        >
    with $FutureModifier<UserGoals>, $FutureProvider<UserGoals> {
  UserGoalsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userGoalsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userGoalsHash();

  @$internal
  @override
  $FutureProviderElement<UserGoals> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserGoals> create(Ref ref) {
    return userGoals(ref);
  }
}

String _$userGoalsHash() => r'245f92a47ff98f19d2001bda29f6fe11159f4be0';
