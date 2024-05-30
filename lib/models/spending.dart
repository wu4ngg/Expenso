import 'package:hdmgr/models/purpose.dart';

class Spending {
  int? id = -1;
  String? title;
  Purpose purpose;
  DateTime? date;
  double? price = 0;
  //constructor
  Spending({this.id, this.title, required this.purpose, this.date, this.price});
  //map
  Map<String, Object?> toMap() {
    return {
      "id": id,
      "title": title,
      "purpose": purpose.id,
      "date": date!.toIso8601String(),
      "price": price
    };
  }
  @override
  String toString() {
    // TODO: implement toString
    return "{$id, $title, $purpose, $date, $price}";
  }
}
