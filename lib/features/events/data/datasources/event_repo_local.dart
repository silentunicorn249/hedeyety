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

  // Ensure database is initialized only once
  @override
  Future<void> initialize(String dbPath) async {
    print("Called");
    print("Initializing database $dbPath...");
    _db =
        await openDatabase(join(await getDatabasesPath(), "my_db"), version: 1);
    print("Database initialized: $_db");
  }

  @override
  Future<void> deleteEvent(String id) async {
    await _db.delete(EVENT_TABLE_NAME, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<EventModel>> getALlEvents() async {
    final result = await _db.query(EVENT_TABLE_NAME);
    final events = result.map((map) => EventModel.fromJson(map)).toList();
    print(events.map((e) => e.toJson()).toList()); // Debug log
    return events;
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
    await _db.insert(
      EVENT_TABLE_NAME,
      event.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateEventPrivateFlag(String eventId, bool isPublic) async {
    await _db.update(
      EVENT_TABLE_NAME,
      {'isPublic': isPublic ? 1 : 0}, // Convert boolean to integer
      where: 'id = ?',
      whereArgs: [eventId],
    );
    print("Updated isPublic flag for event $eventId to ${isPublic ? 1 : 0}");
  }
}
