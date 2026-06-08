// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userData)
final userDataProvider = UserDataProvider._();

final class UserDataProvider
    extends
        $FunctionalProvider<AsyncValue<UserData>, UserData, FutureOr<UserData>>
    with $FutureModifier<UserData>, $FutureProvider<UserData> {
  UserDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userDataHash();

  @$internal
  @override
  $FutureProviderElement<UserData> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserData> create(Ref ref) {
    return userData(ref);
  }
}

String _$userDataHash() => r'9065d5940a2ca2d02a250de60ba1a242d5f0f0a8';
