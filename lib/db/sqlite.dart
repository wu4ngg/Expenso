import 'dart:ffi';
import 'dart:math';

import 'package:hdmgr/models/purpose.dart';
import 'package:hdmgr/models/spending.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer' as developer;

Future<Database> database() async {
  return await openDatabase(join(await getDatabasesPath(), 'spending.db'),
      onUpgrade: (db, oldVersion, newVersion) {
    return db.execute(
        """CREATE TABLE spending (id integer unique primary key, title nvarchar(2000), price double, date date, purpose integer references purpose(id))""");
  }, onCreate: (db, version) {
    db.execute(
        """CREATE TABLE purpose (id integer unique primary key, name nvarchar(2000), iconId integer);""");
    return db.execute(
        """CREATE TABLE spending (id integer unique primary key, title nvarchar(2000), price double, date date, purpose integer references purpose(id))""");
  }, version: 3);
}

Future<List<Purpose>> getPurposes() async {
  final Database db = await database();
  final res = await db.query("purpose");
  return [
    for (final {
          'id': id as int,
          'name': name as String,
          'iconid': iconId as int
        } in res)
      Purpose(id: id, name: name, iconId: iconId)
  ];
}

Future<List<Spending>> getSpending() async {
  final db = await database();
  final res = await db.rawQuery(
      "SELECT S.*, P.id as purposeid, P.name, P.iconid FROM SPENDING S JOIN PURPOSE P ON S.PURPOSE = P.ID");
  developer.log(res.toString());
  return [
    for (final {
          'id': id as int,
          'title': title as String,
          'price': price as double,
          'date': date as String,
          'purposeid': purposeId as int,
          'name': namePurpose as String,
          'iconId': iconId as int
        } in res)
      Spending(
          purpose: Purpose(id: purposeId, name: namePurpose, iconId: iconId),
          id: id,
          title: title,
          price: price,
          date: DateTime.parse(date))
  ];
}

Future<double> getSumPriceSpending(DateTime? date) async {
  final db = await database();
  final total =
      await db.rawQuery("SELECT SUM(PRICE) AS SUM_PRICE, DATE(DATE) AS DATE FROM SPENDING ${date != null ? "WHERE DATE(DATE) = DATE('${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}')" : ""}");
  return double.parse(total[0]['SUM_PRICE'].toString());
}

Future<List<Purpose>> getPurposesById(int id) async {
  final Database db = await database();
  final res = await db.query("purpose", where: "id = ?", whereArgs: [id]);
  developer.log(res.toString());
  return [
    for (final {
          'id': id as int,
          'name': name as String,
          'iconId': iconId as int
        } in res)
      Purpose(id: id, name: name, iconId: iconId)
  ];
}

Future<void> insertSpending(Spending spending) async {
  List<Purpose> purposes = await getPurposesById(spending.purpose.id!);
  final Database db = await database();
  if (purposes.isEmpty) {
    await db.insert("purpose", spending.purpose.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort);
  }
  await db.insert("spending", spending.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}
Future<void> removeSpending(Spending spending) async {
  final Database db = await database();
  db.delete("spending", where: "id = ?", whereArgs: [spending.id]);
}

