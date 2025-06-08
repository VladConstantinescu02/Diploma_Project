// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authenticationHash() => r'2851e0403c13e49a87e8ade2f9ba30a24a28e386';

/// See also [Authentication].
@ProviderFor(Authentication)
final authenticationProvider =
    AutoDisposeAsyncNotifierProvider<Authentication, UserAccount>.internal(
  Authentication.new,
  name: r'authenticationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authenticationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Authentication = AutoDisposeAsyncNotifier<UserAccount>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
