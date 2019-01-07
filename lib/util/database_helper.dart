import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:recodo/model/record.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableRecord = 'noteTable';
  final String columnId = 'id';
  final String columnTitle = 'title';
  final String columnDescription = 'description';

  static Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'records.db');

//    await deleteDatabase(path); // just for testing

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableRecord($columnId INTEGER PRIMARY KEY, $columnTitle TEXT, $columnDescription TEXT)');
  }

  Future<int> saveRecord(Record record) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableRecord, record.toMap());
//    var result = await dbClient.rawInsert(
//        'INSERT INTO $tableRecord ($columnTitle, $columnDescription) VALUES (\'${note.title}\', \'${note.description}\')');

    return result;
  }

  Future<List> getAllRecords() async {
    var dbClient = await db;
    var result = await dbClient.query(tableRecord,
        columns: [columnId, columnTitle, columnDescription]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tableRecord');

    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $tableRecord'));
  }

  Future<Record> getRecord(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableRecord,
        columns: [columnId, columnTitle, columnDescription],
        where: '$columnId = ?',
        whereArgs: [id]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tableRecord WHERE $columnId = $id');

    if (result.length > 0) {
      return new Record.fromMap(result.first);
    }

    return null;
  }

  Future<int> deleteRecord(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableRecord, where: '$columnId = ?', whereArgs: [id]);
//    return await dbClient.rawDelete('DELETE FROM $tableRecord WHERE $columnId = $id');
  }

  Future<int> updateRecord(Record note) async {
    var dbClient = await db;
    return await dbClient.update(tableRecord, note.toMap(),
        where: "$columnId = ?", whereArgs: [note.id]);
//    return await dbClient.rawUpdate(
//        'UPDATE $tableRecord SET $columnTitle = \'${note.title}\', $columnDescription = \'${note.description}\' WHERE $columnId = ${note.id}');
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
