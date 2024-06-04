import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hdmgr/models/settings_item.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  List<SettingsItem> settings = [
    SettingsItem(
      leadingIcon: Icons.attach_money_outlined,
      title: "Cài đặt chi tiêu",
    ),
    SettingsItem(
      leadingIcon: Icons.brush_outlined,
      title: "Giao diện và chủ đề",
    ),
    SettingsItem(
      leadingIcon: Icons.storage_outlined,
      title: "Lưu trữ",
    ),
    SettingsItem(
      leadingIcon: Icons.lock_outline,
      title: "Cài đặt bảo mật",
    ),
    SettingsItem(
      leadingIcon: Icons.description_outlined,
      title: "Điều khoản",
    ),
    SettingsItem(
      leadingIcon: Icons.code,
      title: "Giấy phép mã nguồn mở",
    ),
    SettingsItem(
      leadingIcon: Icons.info_outline,
      title: "Thông tin ứng dụng",
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cài đặt")),
      body: Column(
        children: [
          Material(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 0, left: 20, bottom: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Tài khoản"),
                  Text(
                    "Đăng nhập để có thể lưu trữ các khoản chi tiêu và cài đặt lên đám mây.",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        child: const Text("Đăng nhập"),
                        onPressed: () {},
                      )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: FilledButton(
                        child: const Text("Đăng ký"),
                        onPressed: () {},
                      )),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 0),
                child: ListView.separated(
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(top: index == 0 ? 10 : 0),
                      child: ListTile(
                            leading: Icon(
                              settings[index].leadingIcon,
                              color: Colors.black,
                            ),
                            title: Text(settings[index].title!),
                            onTap: () {},
                          ),
                    ),
                    separatorBuilder: (context, index) => const Divider(indent: 20, endIndent: 20,),
                    itemCount: settings.length),
              ))
        ],
      ),
    );
  }
}
