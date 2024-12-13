import 'package:hedeyety/features/auth/domain/repository/user_repository.dart';
import 'package:sqflite/sqflite.dart';

import '../models/user_model.dart';

class UserRepoLocal implements UserRepository {
  static final UserRepoLocal _instance = UserRepoLocal._();
  late Database _db;
  final String DB_NAME = "users";

  UserRepoLocal._();

  factory UserRepoLocal() => _instance;

  // Ensure database is initialized only once
  Future<void> initialize(String dbPath) async {
    if (_db != null) return; // Prevent re-initializing
    print("Initializing database...");
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
    print("Database initialized: $_db");
  }

  @override
  Future<void> deleteUser(String id) async {
    await _db.delete(DB_NAME, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<UserModel>> getALlUsers() async {
    final result = await _db.query(DB_NAME);
    final objs = result.map((map) => UserModel.fromJson(map)).toList();
    return objs;
  }

  @override
  Future<Map<String, dynamic>?> getUser(String id) async {
    final result = await _db.query(DB_NAME, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await _db.insert(DB_NAME, user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
