import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hdmgr/models/spending.dart';
import 'package:hdmgr/providers/spending_provider.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;

enum Item { delete, edit }

class SpendingCard extends ConsumerStatefulWidget {
  const SpendingCard({super.key, required this.spending, required this.total});
  final Spending spending;
  final double total;
  @override
  ConsumerState<SpendingCard> createState() => _SpendingCardState();
}

class _SpendingCardState extends ConsumerState<SpendingCard> {
  @override
  Widget build(BuildContext context) {
    NumberFormat formatter = NumberFormat("##,###.##");
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Icon(
            IconData(widget.spending.purpose.iconId,
                fontFamily: 'MaterialIcons'),
            size: 32,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: Text(
            widget.spending.title!,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontFamily:
                    GoogleFonts.inter(fontWeight: FontWeight.w100).fontFamily),
          )),
          const SizedBox(
            width: 10,
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(formatter.format(widget.spending.price),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontFamily: GoogleFonts.inter(fontWeight: FontWeight.bold)
                        .fontFamily)),
            const SizedBox(width: 10),
            SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  value: widget.spending.price! / widget.total,
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  color: Theme.of(context).colorScheme.secondary,
                )),
            const SizedBox(width: 5),
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem<Item>(value: Item.edit, child: Text("Sửa")),
                const PopupMenuItem<Item>(
                    value: Item.delete, child: Text("Xoá"))
              ],
              onSelected: (value) {
                if (value == Item.delete) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      icon: const Icon(Icons.warning_outlined),
                      title: Text("Bạn có muốn xoá mục này không?"),
                      actions: [
                        FilledButton(
                            onPressed: () {
                              ref
                                  .read(spendingListProvider.notifier)
                                  .deleteSpending(widget.spending)
                                  .then((value) => Navigator.pop(context));
                            },
                            child: const Text("Có")),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Huỷ"))
                      ],
                    ),
                  );
                }
              },
            )
          ])
        ]));
  }
}
