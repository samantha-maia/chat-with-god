// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authNotifierHash() => r'a3e9650aaa78476cc2c484b15bcfbab965a787a1';

/// See also [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider =
    AutoDisposeNotifierProvider<AuthNotifier, User?>.internal(
      AuthNotifier.new,
      name: r'authNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AuthNotifier = AutoDisposeNotifier<User?>;
String _$userProfileNotifierHash() =>
    r'53ff446e12d7a769fa95954aee1c3eba767ba33b';

/// See also [UserProfileNotifier].
@ProviderFor(UserProfileNotifier)
final userProfileNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      UserProfileNotifier,
      Map<String, dynamic>?
    >.internal(
      UserProfileNotifier.new,
      name: r'userProfileNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userProfileNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserProfileNotifier = AutoDisposeAsyncNotifier<Map<String, dynamic>?>;
String _$dailyUsageNotifierHash() =>
    r'65b6134a8e86e38d81488b00309abb11ce2f6c48';

/// See also [DailyUsageNotifier].
@ProviderFor(DailyUsageNotifier)
final dailyUsageNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      DailyUsageNotifier,
      Map<String, dynamic>?
    >.internal(
      DailyUsageNotifier.new,
      name: r'dailyUsageNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dailyUsageNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DailyUsageNotifier = AutoDisposeAsyncNotifier<Map<String, dynamic>?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
