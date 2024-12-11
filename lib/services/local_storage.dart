import 'package:sqflite/sqflite.dart';

import '../models/storage_interface.dart';

class SqfliteService implements StorageService {
  static final SqfliteService _instance = SqfliteService._internal();

  late Database _db;

  SqfliteService._internal();

  factory SqfliteService() => _instance;

  Future<void> initialize(String dbPath) async {
    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE users (id TEXT PRIMARY KEY, name TEXT, email TEXT, preferences TEXT)');
        db.execute(
            'CREATE TABLE events (id TEXT PRIMARY KEY, name TEXT, date TEXT, location TEXT, description TEXT, userId TEXT)');
        db.execute(
            'CREATE TABLE gifts (id TEXT PRIMARY KEY, name TEXT, description TEXT, category TEXT, price REAL, status TEXT, eventId TEXT)');
        db.execute(
            'CREATE TABLE friends (userId TEXT, friendId TEXT, PRIMARY KEY (userId, friendId))');
      },
    );
  }

  @override
  Future<void> save(
      String collection, int id, Map<String, dynamic> data) async {
    await _db.insert(collection, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<Map<String, dynamic>?> fetch(String collection, String id) async {
    final result =
        await _db.query(collection, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  @override
  Future<void> delete(String collection, String id) async {
    await _db.delete(collection, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAll(String collection) async {
    return await _db.query(collection);
  }
}
