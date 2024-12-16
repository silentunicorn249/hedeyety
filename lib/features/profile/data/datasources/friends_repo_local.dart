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

  // Ensure database is initialized only once
  Future<void> initialize(String dbPath) async {
    print("Called");
    print("Initializing database $dbPath...");
    _db = await openDatabase(
      join(await getDatabasesPath(), "my_db"),
      version: 1,
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
}
