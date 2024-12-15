import 'package:hedeyety/features/auth/domain/repository/user_repository.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/user_model.dart';

class UserRepoLocal implements UserRepository {
  static final UserRepoLocal _instance = UserRepoLocal._();
  late Database _db;
  final DB_PATH = "my_db";
  final String USER_TABLE_NAME = "users";

  UserRepoLocal._();

  factory UserRepoLocal() => _instance;

  // Ensure database is initialized only once
  Future<void> initialize(String dbPath) async {
    print("Called");
    print("Initializing database $dbPath...");
    _db = await openDatabase(
      join(await getDatabasesPath(), dbPath),
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
    await _db.delete(USER_TABLE_NAME, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<UserModel>> getALlUsers() async {
    final result = await _db.query(USER_TABLE_NAME);
    final objs = result.map((map) => UserModel.fromJson(map)).toList();
    print(objs[0].toJson());
    return objs;
  }

  @override
  Future<Map<String, dynamic>?> getUser(String id) async {
    final result =
        await _db.query(USER_TABLE_NAME, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  @override
  Future<void> saveUser(UserModel user) async {
    print("Inserting ${user.toJson()}");
    await _db.insert(USER_TABLE_NAME, user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> eraseAll() async {
    // Drop all tables
    await _db.execute('DROP TABLE IF EXISTS users');
    await _db.execute('DROP TABLE IF EXISTS events');
    await _db.execute('DROP TABLE IF EXISTS gifts');
    await _db.execute('DROP TABLE IF EXISTS friends');

    print("Deleted old DBs");

    // Recreate the tables
    await initialize(DB_PATH);
  }
}
