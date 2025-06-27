// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_conversations_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$favoriteConversationsNotifierHash() =>
    r'24f92fd03c5a9238f8f3ba2c64a1eed02d5a9cc8';

/// See also [FavoriteConversationsNotifier].
@ProviderFor(FavoriteConversationsNotifier)
final favoriteConversationsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      FavoriteConversationsNotifier,
      List<Map<String, dynamic>>
    >.internal(
      FavoriteConversationsNotifier.new,
      name: r'favoriteConversationsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$favoriteConversationsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FavoriteConversationsNotifier =
    AutoDisposeAsyncNotifier<List<Map<String, dynamic>>>;
String _$favoriteConversationsCountHash() =>
    r'232029a98a72eaacc781f978ecc9348ec0ad6822';

/// See also [FavoriteConversationsCount].
@ProviderFor(FavoriteConversationsCount)
final favoriteConversationsCountProvider =
    AutoDisposeAsyncNotifierProvider<FavoriteConversationsCount, int>.internal(
      FavoriteConversationsCount.new,
      name: r'favoriteConversationsCountProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$favoriteConversationsCountHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FavoriteConversationsCount = AutoDisposeAsyncNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
