import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:todo/app/database/migrations/migration_v1.dart';
import 'package:todo/app/database/migrations/migration_v2.dart';

class Connection {
  static const VERSION = 1;
  static const DATABASE_NAME = 'TODO_LIST';

  static Connection _instance;
  Database _db;
  final _look = Lock();

  factory Connection() {
    if (_instance == null) {
      _instance = Connection._();
    }
    return _instance;
  }

  Connection._();

  Future<Database> get instance async => await _openConnection();

  Future<Database> _openConnection() async {
    var databasePath = await getDatabasesPath();
    var pathDataBase = join(databasePath, DATABASE_NAME);
    if (_db == null) {
      await _look.synchronized(() async {
        if (_db == null) {
          _db = await openDatabase(pathDataBase,
              version: VERSION,
              onConfigure: __onConfigure,
              onCreate: _onCreate,
              onUpgrade: _onUpgrade);
        }
      });
    }
    return _db;
  }

  void closeConncetion() {
    _db?.close();
    _db = null;
  }

  FutureOr<void> __onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  FutureOr<void> _onCreate(Database db, int version) {
    var batch = db.batch();
    createV1(batch);
    createV2(batch);
    batch.commit();
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) {
    var batch = db.batch();

    upgradeV2(batch);
    batch.commit();
  }
}
