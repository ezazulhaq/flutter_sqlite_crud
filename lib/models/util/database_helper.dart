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
    return await db.insert(Contact.tblContacts, contact.toMap());
  }

  Future<List<Contact>> fetchContacts() async {
    Database db = await database;
    List<Map> contacts = await db.query(Contact.tblContacts);
    return contacts.length == 0
        ? []
        : contacts.map((e) => Contact.fromMap(e)).toList();
  }

  Future<int> updateContact(Contact contact) async {
    Database db = await database;
    return await db.update(
      Contact.tblContacts,
      contact.toMap(),
      where: "${Contact.colId}=?",
      whereArgs: [contact.id],
    );
  }

  Future<void> updateContactOld(int id, String name, String mobile) async {
    Database db = await database;
    await db.rawUpdate('''
      update ${Contact.tblContacts} 
      set 
        ${Contact.colName} = $name,
        ${Contact.colMobile} = $mobile
      where
        ${Contact.colId} = $id
      ''');
  }

  Future<int> deleteContact(Contact contact) async {
    Database db = await database;
    return await db.delete(
      Contact.tblContacts,
      where: "${Contact.colId}=?",
      whereArgs: [contact.id],
    );
  }

  Future<void> deleteAllData() async {
    Database db = await database;
    await db.rawDelete("delete from ${Contact.tblContacts}");
  }
}
