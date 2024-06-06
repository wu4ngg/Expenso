// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spending_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$spendingHash() => r'4ee86ca286ceb8ac2b99aea4b0c461f0a0aef40e';

/// See also [spending].
@ProviderFor(spending)
final spendingProvider = AutoDisposeFutureProvider<SpendingData>.internal(
  spending,
  name: r'spendingProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$spendingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SpendingRef = AutoDisposeFutureProviderRef<SpendingData>;
String _$spendingListHash() => r'31864e0afa1dd96fd63c9db045223bd215c2b6e7';

/// See also [SpendingList].
@ProviderFor(SpendingList)
final spendingListProvider =
    AutoDisposeAsyncNotifierProvider<SpendingList, SpendingData>.internal(
  SpendingList.new,
  name: r'spendingListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$spendingListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SpendingList = AutoDisposeAsyncNotifier<SpendingData>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
