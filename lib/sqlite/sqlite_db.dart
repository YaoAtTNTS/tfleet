

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tfleet/model/notification.dart';

class SqliteDb {

  SqliteDb._();

  static final SqliteDb _instance = SqliteDb._();

  static SqliteDb get instance => _instance;

  Database? _database;

  void close () async {
    await _database!.close();
    _database = null;
  }

  Future initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'tfleet.db');
    _database = await openDatabase(path,
      version: 1,
      onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE IF NOT EXISTS notification (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT, time TEXT, status INTEGER)');
      }
    );
  }

  Future insertNotification(Notification notification) async {
    await _database?.insert('notification', notification.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future queryNotification(int offset) async {
    List<Map<String, dynamic>>? results = await _database?.query(
        'notification',
      orderBy: 'id DESC',
      limit: 50,
      offset: offset
    );
    if (results != null) {
      List<Notification> list = [];
      for (Map<String, dynamic> item in results) {
        list.add(Notification.fromJson(item));
      }
      return list;
    }
    return null;
  }

}