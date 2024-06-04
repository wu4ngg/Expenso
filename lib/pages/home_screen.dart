import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hdmgr/components/error.dart';
import 'package:hdmgr/components/spending_card.dart';
import 'package:hdmgr/components/statsbar.dart';
import 'package:hdmgr/db/sqlite.dart';
import 'package:hdmgr/models/purpose.dart';
import 'package:hdmgr/models/spending.dart';
import 'dart:developer' as developer;
import 'package:hdmgr/models/spending_data.dart';
import 'package:hdmgr/providers/spending_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime date = DateTime.now();
  final List<Spending> list = List.generate(
      100,
      (index) => Spending(
          purpose: Purpose(iconId: Icons.abc.codePoint),
          id: 1,
          title: "Testing",
          price: 40000));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text("Trang chủ"),
        actions: [
          FilledButton(
            onPressed: () {},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.calendar_month_outlined,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text("${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}")
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                getSpending().then((value) => developer.log(value.toString()));
                getSumPriceSpending(DateTime.now())
                    .then((value) => developer.log(value.toString()));
              },
              icon: const Icon(Icons.refresh_outlined))
        ],
      ),
      body: Column(
        children: <Widget>[
          const StatsBar(),
          Expanded(child: Consumer(
            builder: (context, ref, child) {
              final AsyncValue<SpendingData> spendingData =
                  ref.watch(spendingListProvider);
              return switch (spendingData) {
                AsyncData(:final value) => value.spendings!.length > 0 ? ListView.separated(
                    itemCount: value.spendings!.length,
                    separatorBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                            height: 2,
                            child: Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground))),
                    itemBuilder: (context, index) =>
                        SpendingCard(spending: value.spendings![index], total: value.spendingCount,),
                  ) : const Center(child: ErrorScreen(icon: Icons.list_alt, title: "Danh sách trống", subtitle: "Hãy ấn nút 'Thêm mục chi tiêu' để bắt đầu quản lý chi tiêu!"),),
                  AsyncError(:final error, :final stackTrace) => Center(child: ErrorScreen(icon: Icons.list_alt, title: "Lỗi!", subtitle: 'Đã xảy ra lỗi trong quá trình nhận thông tin \n thông tin lỗi: $error'),),
                _ => Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary,),)
              };
            },
          ))
        ],
      ),
    );
  }
}
