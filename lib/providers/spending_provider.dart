import 'package:flutter/material.dart';
import 'package:hdmgr/db/sqlite.dart';
import 'package:hdmgr/models/spending.dart';
import 'package:hdmgr/models/spending_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:developer' as developer;
part 'spending_provider.g.dart';
@riverpod
Future<SpendingData> spending(SpendingRef ref) async{
  final res = await getSpending();
  final sum = await getSumPriceSpending(null);
  developer.log(res.toString());
  return SpendingData(res, sum);
}
@riverpod
class SpendingList extends _$SpendingList{
  DateTime date = DateTime.now();
  @override 
  Future<SpendingData> build() async {
    final res = await getSpending();
    final sum = await getSumPriceSpending(null);
    developer.log(res.toString());
    return SpendingData(res, sum);
  }
  Future<SpendingData> revalidateSpending() async{
  final res = await getSpending();
  final sum = await getSumPriceSpending(null);
  developer.log(res.toString());
  return SpendingData(res, sum);
}
  Future<void> addSpending(Spending spending) async {
    await insertSpending(spending);
    ref.invalidateSelf();
    await future;
  }
  Future<void> deleteSpending(Spending spending) async {
    await removeSpending(spending);
    ref.invalidateSelf();
    await future;
  }
}