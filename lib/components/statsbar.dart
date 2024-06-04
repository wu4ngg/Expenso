import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hdmgr/dialog/add_item.dart';
import 'package:hdmgr/models/spending_data.dart';
import 'package:hdmgr/models/user_data.dart';
import 'package:hdmgr/providers/spending_provider.dart';
import 'package:hdmgr/providers/user_settings_provider.dart';
import 'package:intl/intl.dart';

class StatsBar extends ConsumerWidget {
  const StatsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void showAddItemDialog(BuildContext context) {
      showDialog(context: context, builder: (context) => const AddItemDialog());
    }

    final AsyncValue<SpendingData> spending = ref.watch(spendingListProvider);
    final userData = ref.watch(userSettingsProvider);
    NumberFormat formatter = NumberFormat("##,###.##");
    double cur = 0;
    double target = 100000;
    switch (spending) {
      case AsyncData(:final value):
        cur = value.spendingCount;
        break;
      case AsyncError():
        cur = -2;
        break;
      default:
        cur = -1;
        break;
    }
    return Material(
        elevation: 15,
        child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Tổng chi tiêu"),
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: cur),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeInOutCubicEmphasized,
                    builder: (context, value, child) => AutoSizeText(
                        "${formatter.format(value)}/${formatter.format(target)}₫",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                color: cur >= target
                                    ? Theme.of(context).colorScheme.error
                                    : Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                        maxLines: 1),
                  ),
                  cur > target
                      ? RichText(
                          text: TextSpan(
                              text: "💸 Bạn đã chi tiêu quá ",
                              style: DefaultTextStyle.of(context).style,
                              children: [
                              TextSpan(
                                  text: formatter.format(cur - target),
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold)),
                              const TextSpan(text: " so với kế hoạch")
                            ]))
                      : const SizedBox(),
                  const SizedBox(height: 10),
                  TweenAnimationBuilder(
                    curve: Curves.easeInOutCubicEmphasized,
                    tween: Tween<double>(
                      begin: 0,
                      end: cur / target,
                    ),
                    duration: const Duration(milliseconds: 1000),
                    builder: (context, value, child) => LinearProgressIndicator(
                        minHeight: 10,
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        value: value,
                        color: cur >= target
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.secondary),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                      child: FilledButton(
                          onPressed: () {
                            showAddItemDialog(context);
                          },
                          child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add),
                                Text("Thêm mục chi tiêu")
                              ])))
                ])));
  }
}
