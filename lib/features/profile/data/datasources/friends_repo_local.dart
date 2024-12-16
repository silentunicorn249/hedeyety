import 'package:hedeyety/features/auth/domain/repository/friend_repository.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/repository/friend_repository.dart';
import '../models/friend_model.dart';

class FriendRepoLocal implements FriendRepository {
  static final FriendRepoLocal _instance = FriendRepoLocal._();
  late Database _db;
  final DB_PATH = "my_db";
  final String USER_TABLE_NAME = "friends";

  FriendRepoLocal._();

  factory FriendRepoLocal() => _instance;

  Future<void> initCommands(Database db) async {
    print("Creating tables");
    db.execute(
        'CREATE TABLE friends (id TEXT PRIMARY KEY, name TEXT, phoneNo TEXT, email TEXT, preferences TEXT)');
    db.execute(
        'CREATE TABLE events (id TEXT PRIMARY KEY, name TEXT, date TEXT, location TEXT, description TEXT, friendId TEXT)');
    db.execute(
        'CREATE TABLE gifts (id TEXT PRIMARY KEY, name TEXT, description TEXT, category TEXT, price REAL, status TEXT, eventId TEXT)');
    db.execute(
        'CREATE TABLE friends (friendId TEXT, friendId TEXT, PRIMARY KEY (friendId, friendId))');
  }

  // Ensure database is initialized only once
  Future<void> initialize(String dbPath) async {
    print("Called");
    print("Initializing database $dbPath...");
    _db = await openDatabase(
      join(await getDatabasesPath(), "local_db"),
      version: 1,
      onCreate: (db, version) {
        initCommands(db);
      },
    );
    print("Database initialized: $_db");
  }

  @override
  Future<void> deleteFriend(String id) async {
    await _db.delete(USER_TABLE_NAME, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<FriendModel>> getALlFriends() async {
    final result = await _db.query(USER_TABLE_NAME);
    final objs = result.map((map) => FriendModel.fromJson(map)).toList();
    print(objs[0].toJson());
    return objs;
  }

  @override
  Future<FriendModel?> getFriend(String id) async {
    final result =
        await _db.query(USER_TABLE_NAME, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? FriendModel.fromJson(result.first) : null;
  }

  @override
  Future<void> saveFriend(FriendModel friend) async {
    print("Inserting ${friend.toJson()}");
    await _db.insert(USER_TABLE_NAME, friend.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> eraseAll() async {
    // Drop all tables
    await _db.execute('DROP TABLE IF EXISTS friends');
    await _db.execute('DROP TABLE IF EXISTS events');
    await _db.execute('DROP TABLE IF EXISTS gifts');
    await _db.execute('DROP TABLE IF EXISTS friends');
    print("Deleted old DBs");

    // Recreate the tables
    await initCommands(_db);
  }
}
