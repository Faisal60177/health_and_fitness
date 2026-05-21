// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exerciseDetailHash() => r'a56f9b11e78da399cf1a4232504ea86ab9a4c7eb';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [exerciseDetail].
@ProviderFor(exerciseDetail)
const exerciseDetailProvider = ExerciseDetailFamily();

/// See also [exerciseDetail].
class ExerciseDetailFamily extends Family<AsyncValue<ExerciseCache?>> {
  /// See also [exerciseDetail].
  const ExerciseDetailFamily();

  /// See also [exerciseDetail].
  ExerciseDetailProvider call(
    int apiId,
  ) {
    return ExerciseDetailProvider(
      apiId,
    );
  }

  @override
  ExerciseDetailProvider getProviderOverride(
    covariant ExerciseDetailProvider provider,
  ) {
    return call(
      provider.apiId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'exerciseDetailProvider';
}

/// See also [exerciseDetail].
class ExerciseDetailProvider extends AutoDisposeFutureProvider<ExerciseCache?> {
  /// See also [exerciseDetail].
  ExerciseDetailProvider(
    int apiId,
  ) : this._internal(
          (ref) => exerciseDetail(
            ref as ExerciseDetailRef,
            apiId,
          ),
          from: exerciseDetailProvider,
          name: r'exerciseDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$exerciseDetailHash,
          dependencies: ExerciseDetailFamily._dependencies,
          allTransitiveDependencies:
              ExerciseDetailFamily._allTransitiveDependencies,
          apiId: apiId,
        );

  ExerciseDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.apiId,
  }) : super.internal();

  final int apiId;

  @override
  Override overrideWith(
    FutureOr<ExerciseCache?> Function(ExerciseDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExerciseDetailProvider._internal(
        (ref) => create(ref as ExerciseDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        apiId: apiId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ExerciseCache?> createElement() {
    return _ExerciseDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExerciseDetailProvider && other.apiId == apiId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, apiId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ExerciseDetailRef on AutoDisposeFutureProviderRef<ExerciseCache?> {
  /// The parameter `apiId` of this provider.
  int get apiId;
}

class _ExerciseDetailProviderElement
    extends AutoDisposeFutureProviderElement<ExerciseCache?>
    with ExerciseDetailRef {
  _ExerciseDetailProviderElement(super.provider);

  @override
  int get apiId => (origin as ExerciseDetailProvider).apiId;
}

String _$exerciseNotifierHash() => r'dede7112c599c7fc05bd486b392e3a00f72cb136';

/// See also [ExerciseNotifier].
@ProviderFor(ExerciseNotifier)
final exerciseNotifierProvider =
    AutoDisposeNotifierProvider<ExerciseNotifier, ExerciseState>.internal(
  ExerciseNotifier.new,
  name: r'exerciseNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$exerciseNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExerciseNotifier = AutoDisposeNotifier<ExerciseState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
