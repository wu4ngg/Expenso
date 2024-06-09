import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hdmgr/models/spending_limit.dart';
import 'package:hdmgr/models/user_data.dart';
import 'package:hdmgr/providers/user_settings_provider.dart';
import 'package:path/path.dart';

enum Choices { all, every }

class ExpenseSettings extends ConsumerStatefulWidget {
  const ExpenseSettings({super.key});

  @override
  ConsumerState<ExpenseSettings> createState() => _ExpenseSettingsState();
}

class _ExpenseSettingsState extends ConsumerState<ExpenseSettings> {
  final List<(int, double)> daysOfWeek = [
    (DateTime.monday, 0),
    (DateTime.tuesday, 0),
    (DateTime.wednesday, 0),
    (DateTime.thursday, 0),
    (DateTime.friday, 0),
    (DateTime.saturday, 0),
    (DateTime.sunday, 0),
  ];
  late Set<(int, double)> selection = {daysOfWeek.first};
  int recentlySelected = 0;
  Choices choice = Choices.all;
  TextEditingController controller = TextEditingController();
  List<String> values = [];
  Future<void>? saveSettingsFuture;
  Future<UserData> getExpenseLimitAsUserData() async {
    return await ref.watch(userSettingsProvider.future);
  }

  Future<void> getExpenseLimit(int day) async {
    UserData userData = UserData();
    if (day == -1) {
      UserData? asyncData = await ref.watch(userSettingsProvider.future);
      userData = asyncData!;
    } else {
      userData = UserData(
          spendingLimitList: [SpendingLimit(value: selection.first.$2)]);
    }
    controller.value = TextEditingValue(
        text: userData.spendingLimitList![0].value.toString() == '0.0'
            ? ''
            : userData.spendingLimitList![0].value.toString());
    //TODO: get weekday expense limit
  }

  Future<void> setExpenseLimit(
      BuildContext context, List<(String, int, double)> param) async {
    if (param[0].$3 <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text("Bạn không thể đặt giới hạn chi tiêu bằng 0 hoặc âm!")));
      return;
    }
    switch (choice) {
      case Choices.all:
        setState(() {
          if (values.isNotEmpty) {
            values[0] = ("${param[0].$1}, ${param[0].$3}");
          } else {
            values.add("${param[0].$1}, ${param[0].$3}");
          }
        });

        try {
          await ref
              .watch(userSettingsProvider.notifier)
              .setSpendingLimit(values);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Lưu cài đặt thành công!")));
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Lưu cài đặt thất bại: $e")));
            return;
          }
        }
        break;
      default:
        var emptyValueList = param.where((v) => v.$3 == 0).map((e) {
          if (e.$2 == 7) {
            return "CN";
          } else {
            return (e.$2 + 1).toString();
          }
        });
        var allOptionUserData = await getExpenseLimitAsUserData();
        if (context.mounted) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    icon: const Icon(Icons.warning_outlined),
                    title: const Text(
                        "Các ngày có giá trị trống sẽ được lắp đầy."),
                    content: Text(
                      "Các ngày thứ ${emptyValueList.join(', ')} có giá trị trống và sẽ được lắp đầy bằng giá trị của tuỳ chọn 'Tất cả'. Tức là ${allOptionUserData.spendingLimitList![0].value} đồng.",
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      FilledButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Huỷ")),
                      ElevatedButton(
                          onPressed: () {
                            //TODO: Save
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Lưu cài đặt thành công!")));
                          },
                          child: const Text("Ok"))
                    ],
                  ));
        } else {
          return;
        }
        break;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getExpenseLimit(choice == Choices.all ? -1 : selection.first.$1);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cài đặt chi tiêu"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: FutureBuilder(
            future: saveSettingsFuture,
            builder: (context, snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  snapshot.connectionState == ConnectionState.waiting
                      ? const Column(
                          children: [
                            SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text("Đang lưu...")
                              ],
                            ),
                            SizedBox(height: 16),
                          ],
                        )
                      : const SizedBox(),
                  Text("Giới hạn chi tiêu",
                      style: Theme.of(context).textTheme.titleMedium),
                  Text(
                    "Đặt giới hạn cho các khoản chi tiêu trong ngày của bạn, khi vượt khoản chi tiêu này, ứng dụng sẽ thông báo cho bạn.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SegmentedButton<Choices>(
                          selected: <Choices>{choice},
                          segments: [
                            ButtonSegment<Choices>(
                                value: Choices.all, label: Text("Tất cả")),
                            ButtonSegment<Choices>(
                                value: Choices.every,
                                label: Text("Ngày trong tuần"))
                          ],
                          onSelectionChanged: snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? null
                              : (val) {
                                  setState(() {
                                    choice = val.first;
                                    controller.text = "0";
                                  });
                                },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: SegmentedButton(
                        emptySelectionAllowed: false,
                        showSelectedIcon: false,
                        selected: selection,
                        segments: daysOfWeek
                            .map((e) => ButtonSegment(
                                  value: e,
                                  label: Badge(
                                    smallSize: e.$2 != 0 ? 4 : 0,
                                    child: Text(e.$1 == 7
                                        ? "CN"
                                        : "T${(e.$1 + 1).toString()}"),
                                  ),
                                ))
                            .toList(),
                        onSelectionChanged: choice == Choices.all
                            ? null
                            : (p0) {
                                selection = p0 as Set<(int, double)>;
                                setState(() {});
                              },
                      ))
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      label: Text("Đặt giới hạn (Ví dụ: 100000)"),
                    ),
                    readOnly:
                        snapshot.connectionState == ConnectionState.waiting,
                    keyboardType: TextInputType.number,
                    onEditingComplete: () {
                      setState(() {
                        double? val = double.tryParse(controller.text);
                        if (val == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Giá trị không hợp lệ!")));
                          return;
                        }
                        if (choice == Choices.every) {
                          var value = (
                            selection.first.$1,
                            double.parse(controller.text)
                          );
                          daysOfWeek[daysOfWeek.indexOf(selection.first)] =
                              value;
                          selection = {
                            value.$1 >= daysOfWeek.length
                                ? daysOfWeek[0]
                                : daysOfWeek[value.$1]
                          };
                          setState(() {});
                        }
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                if (choice == Choices.all) {
                                  saveSettingsFuture = setExpenseLimit(
                                      context, [
                                    ("all", -1, double.parse(controller.text))
                                  ]);
                                  FocusManager.instance.primaryFocus?.unfocus();
                                } else {
                                  saveSettingsFuture = setExpenseLimit(
                                      context,
                                      daysOfWeek
                                          .map<(String, int, double)>(
                                              (e) => ("every", e.$1, e.$2))
                                          .toList());
                                }
                              },
                              child: const Text("Lưu"))),
                    ],
                  )
                ],
              );
            }),
      ),
    );
  }
}
