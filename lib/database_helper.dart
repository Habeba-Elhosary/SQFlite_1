import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import 'model.dart';

class DatabaseHelper {
  //TODO VARIABLES *************************
  static const String _databaseName = 'users.db'; // Database Name
  static const int _databaseVersion = 1; // Database Version
  static const String _tableName = 'users'; // Table Name
  static const String _columnId = 'id'; // ID Column Name
  static const String _columnUserName = 'username'; //Username Column Name
  static const String _columnEmail = 'email'; //Email Column Name
  //TODO Singleton **************************
  DatabaseHelper._internal(); //Private Constructor
  static final DatabaseHelper instance =
      DatabaseHelper._internal(); //Create Instance Of Private Constructor
  static Database? _db; //Database Variable
  //TODO Check Database *************************
  Future<Database> get _database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  //TODO Initial Database ***************************
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final String path = '$dbPath/$_databaseName';
    log(path);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  //TODO CREATE DATABASE ****************************
  _onCreate(Database db, int version) async {
    db.execute('''
CREATE TABLE $_tableName (
  $_columnId INTEGER PRIMARY KEY,
  $_columnUserName TEXT NOT NULL,
  $_columnEmail TEXT NOT NULL
)
''');
  }

  //TODO GET ALL USERS FROM DATABASE ***********************
  Future<List<User>> getAllUsers() async {
    Database db = await instance._database;
    List<Map<String, dynamic>> response = await db.query(_tableName, columns: [
      _columnId,
      _columnUserName,
      _columnEmail,
    ]);
    return response.map((e) => User.fromMap(e)).toList();
  }

  //TODO INSERT TO DATABASE ***********************
  Future<int> insertToDatabase(User user) async {
    Database db = await instance._database;
    return await db.insert(_tableName, user.toMap());
  }

  //TODO DELETE FROM DATABASE ***********************
  Future<int> deleteFromDatabase(int id) async {
    Database db = await instance._database;
    return await db
        .delete(_tableName, where: '$_columnId = ?', whereArgs: [id]);
  }

  //TODO UPDATE FROM DATABASE ***********************
  Future<int> updateData(User user, int id) async {
    Database db = await instance._database;
    return await db.update(_tableName, user.toMap(),
        where: '$_columnId = ?', whereArgs: [user.id]);
  }

  //TODO SEARCH FROM DATABASE ***********************
  searchFromDatabase(String input) async {
    Database db = await instance._database;
    List<Map<String, dynamic>> response = await db.query(_tableName,
        where: '$_columnUserName LIKE ?', whereArgs: ['$input%']);
    return response.map((e) => User.fromMap(e)).toList();
  }
}
