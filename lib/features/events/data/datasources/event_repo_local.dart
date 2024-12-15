import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/repository/event_repository.dart';
import '../models/event_model.dart';

class EventRepoLocal implements EventRepository {
  static final EventRepoLocal _instance = EventRepoLocal._();
  late Database _db;
  final DB_PATH = "my_db";
  final String EVENT_TABLE_NAME = "events";

  EventRepoLocal._();

  factory EventRepoLocal() => _instance;

  Future<void> initCommands(Database db) async {
    print("Creating tables");
    db.execute(
        'CREATE TABLE events (id TEXT PRIMARY KEY, name TEXT, phoneNo TEXT, email TEXT, preferences TEXT)');
    db.execute(
        'CREATE TABLE events (id TEXT PRIMARY KEY, name TEXT, date TEXT, location TEXT, description TEXT, eventId TEXT)');
    db.execute(
        'CREATE TABLE gifts (id TEXT PRIMARY KEY, name TEXT, description TEXT, category TEXT, price REAL, status TEXT, eventId TEXT)');
    db.execute(
        'CREATE TABLE friends (eventId TEXT, friendId TEXT, PRIMARY KEY (eventId, friendId))');
  }

  // Ensure database is initialized only once
  @override
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
  Future<void> deleteEvent(String id) async {
    await _db.delete(EVENT_TABLE_NAME, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<EventModel>> getALlEvents() async {
    final result = await _db.query(EVENT_TABLE_NAME);
    final objs = result.map((map) => EventModel.fromJson(map)).toList();
    print(objs[0].toJson());
    return objs;
  }

  @override
  Future<EventModel?> getEvent(String id) async {
    final result =
        await _db.query(EVENT_TABLE_NAME, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? EventModel.fromJson(result.first) : null;
  }

  @override
  Future<void> saveEvent(EventModel event) async {
    print("Inserting ${event.toJson()}");
    await _db.insert(EVENT_TABLE_NAME, event.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> eraseAll() async {
    // Drop all tables
    await _db.execute('DROP TABLE IF EXISTS events');
    await _db.execute('DROP TABLE IF EXISTS events');
    await _db.execute('DROP TABLE IF EXISTS gifts');
    await _db.execute('DROP TABLE IF EXISTS friends');
    print("Deleted old DBs");

    // Recreate the tables
    await initCommands(_db);
  }
}
