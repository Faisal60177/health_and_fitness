// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$leaderboardHash() => r'6ef55d72ca00d0e733753e77604f23cba583fd1f';

/// See also [leaderboard].
@ProviderFor(leaderboard)
final leaderboardProvider =
    AutoDisposeStreamProvider<List<LeaderboardEntry>>.internal(
  leaderboard,
  name: r'leaderboardProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$leaderboardHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LeaderboardRef = AutoDisposeStreamProviderRef<List<LeaderboardEntry>>;
String _$leaderboardSyncHash() => r'601fc8cd51d00319663522774000942ea6f49410';

/// See also [LeaderboardSync].
@ProviderFor(LeaderboardSync)
final leaderboardSyncProvider =
    AutoDisposeNotifierProvider<LeaderboardSync, bool>.internal(
  LeaderboardSync.new,
  name: r'leaderboardSyncProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$leaderboardSyncHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LeaderboardSync = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
