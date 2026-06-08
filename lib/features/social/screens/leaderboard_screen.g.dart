// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(leaderboard)
final leaderboardProvider = LeaderboardProvider._();

final class LeaderboardProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LeaderboardEntry>>,
          List<LeaderboardEntry>,
          Stream<List<LeaderboardEntry>>
        >
    with
        $FutureModifier<List<LeaderboardEntry>>,
        $StreamProvider<List<LeaderboardEntry>> {
  LeaderboardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaderboardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaderboardHash();

  @$internal
  @override
  $StreamProviderElement<List<LeaderboardEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<LeaderboardEntry>> create(Ref ref) {
    return leaderboard(ref);
  }
}

String _$leaderboardHash() => r'69f0aeadcd559362096189c5712d33279e63b2e4';

@ProviderFor(LeaderboardSync)
final leaderboardSyncProvider = LeaderboardSyncProvider._();

final class LeaderboardSyncProvider
    extends $NotifierProvider<LeaderboardSync, bool> {
  LeaderboardSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaderboardSyncProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaderboardSyncHash();

  @$internal
  @override
  LeaderboardSync create() => LeaderboardSync();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$leaderboardSyncHash() => r'601fc8cd51d00319663522774000942ea6f49410';

abstract class _$LeaderboardSync extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
