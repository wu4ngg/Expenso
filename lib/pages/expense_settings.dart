import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  Choices choice = Choices.all;
  TextEditingController controller = TextEditingController();
  List<String> values = [];
  Future<void>? saveSettingsFuture;
  Future<void> getExpenseLimit(int day) async {
    UserData userData = UserData();
    if (day == -1) {
      UserData? asyncData = await ref.watch(userSettingsProvider.future);
      userData = asyncData!;
    }
    controller.value =
        TextEditingValue(text: userData.spendingLimitList![0].value.toString());
    //TODO: get weekday expense limit
  }

  Future<void> setExpenseLimit(
      BuildContext context, (String, int, double) value) async {
    if (value.$3 <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text("Bạn không thể đặt giới hạn chi tiêu bằng 0 hoặc âm!")));
      return;
    }
    switch (choice) {
      case Choices.all:
        setState(() {
          if (values.isNotEmpty) {
            values[0] = ("${value.$1}, ${value.$3}");
          } else {
            values.add("${value.$1}, ${value.$3}");
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
          }
        }
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getExpenseLimit(-1);
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
                                  });
                                },
                        ),
                      ),
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
                        saveSettingsFuture = setExpenseLimit(context,
                            ("all", -1, double.parse(controller.text)));
                        FocusManager.instance.primaryFocus?.unfocus();
                      });
                    },
                  )
                ],
              );
            }),
      ),
    );
  }
}
