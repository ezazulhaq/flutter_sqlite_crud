import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqlite_crud/models/contact.dart';

class DatabaseHelper {
  static const _databaseName = "ContactData.db";
  static const _databaseVersion = 1;

  //singleton Class
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDataBase();
    return _database;
  }

  Future<Database> _initDataBase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path, _databaseName);

    return await openDatabase(
      dbPath,
      version: _databaseVersion,
      onCreate: _onCreateDB,
    );
  }

  void _onCreateDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${Contact.tblContacts}(
        ${Contact.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Contact.colName} TEXT NOT  NULL,
        ${Contact.colMobile} TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertContact(Contact contact) async {
    Database db = await database;
    return db.insert(Contact.tblContacts, contact.toMap());
  }
}
