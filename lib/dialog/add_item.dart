import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hdmgr/models/purpose.dart';
import 'package:hdmgr/models/spending.dart';
import 'package:hdmgr/providers/spending_provider.dart';

class AddItemDialog extends ConsumerStatefulWidget {
  const AddItemDialog({super.key});

  @override
  ConsumerState<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends ConsumerState<AddItemDialog> {
  int _selectedIndex = 0;
  Future<void>? _pendingAddSpending;
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  void insert(Spending spending, BuildContext context) {
    final future = ref
        .read(spendingListProvider.notifier)
        .addSpending(spending)
        .then((value) {
      if (context.mounted) {
        Navigator.pop(context);
      }
    });
    _pendingAddSpending = future;
  }

  List<Purpose> purposes = [
    Purpose(
        id: 0,
        name: "Đi xe bus",
        iconId: Icons.directions_bus_outlined.codePoint),
    Purpose(
        id: 3, name: "Ăn trưa", iconId: Icons.restaurant_outlined.codePoint),
    Purpose(id: 1, name: "Ăn nhẹ", iconId: Icons.cookie_outlined.codePoint),
    Purpose(id: 2, name: "Đi cafe", iconId: Icons.coffee_outlined.codePoint),
  ];
  bool _saveToCloud = true;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Thêm khoản chi tiêu",
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Mục đích chi tiêu",
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: "Tìm kiếm",
                                contentPadding: EdgeInsets.all(10),
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                )),
                          ),
                        ),
                        const SizedBox(width: 5),
                        FilledButton(onPressed: () {}, child: Icon(Icons.add))
                      ],
                    ),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: purposes.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                          child: Card(
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                color: _selectedIndex == index
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.surfaceTint,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                        IconData(purposes[index].iconId,
                                            fontFamily: "MaterialIcons"),
                                        size: 34),
                                    Text(purposes[index].name!)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text("Chi tiết chi tiêu",
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        label:
                            Text("Nội dung chi tiêu  (vd: Cơm gà xối mỡ...)"),
                      ),
                      controller: titleController,
                      onChanged: (value) {
                        setState(() {
                          
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        label: Text("Số tiền"),
                      ),
                      keyboardType: TextInputType.number,
                      controller: priceController,
                      onChanged: (value) {
                        setState(() {
                          
                        });
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                  onTap: () {
                    setState(() {
                      _saveToCloud = !_saveToCloud;
                    });
                  },
                  leading: Switch(
                      value: _saveToCloud,
                      onChanged: (value) => setState(() {
                            _saveToCloud = value;
                          })),
                  title: Text(
                    "Lưu vào đám mây",
                    style: Theme.of(context).textTheme.labelLarge,
                  )),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                        child: FutureBuilder(
                      future: _pendingAddSpending,
                      builder: (context, snapshot) => ElevatedButton(
                        onPressed: titleController.text != "" &&
                                priceController.text != ""
                            ? () {
                                insert(
                                    Spending(
                                        title: titleController.text,
                                        price:
                                            double.parse(priceController.text),
                                        date: DateTime.now(),
                                        purpose: purposes[_selectedIndex]),
                                    context);
                              }
                            : null,
                        child:
                            snapshot.connectionState == ConnectionState.waiting
                                ? const CircularProgressIndicator()
                                : snapshot.hasError &&
                                        snapshot.connectionState !=
                                            ConnectionState.waiting
                                    ? const Icon(Icons.error)
                                    : const Text("Thêm"),
                      ),
                    )),
                    const SizedBox(width: 10),
                    Expanded(
                        child: FilledButton(
                      child: const Text("Huỷ"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
