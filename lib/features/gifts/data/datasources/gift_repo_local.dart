import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/repositories/gift_repository.dart';
import '../models/gift_model.dart';

class GiftRepoLocal implements GiftRepository {
  static final GiftRepoLocal _instance = GiftRepoLocal._();
  late Database _db;
  final DB_PATH = "my_db";
  final String GIFT_TABLE_NAME = "gifts";

  GiftRepoLocal._();

  factory GiftRepoLocal() => _instance;

  @override
  Future<void> initialize(String dbPath) async {
    _db = await openDatabase(
      join(await getDatabasesPath(), dbPath),
      version: 1,
    );
  }

  @override
  Future<void> saveGift(GiftModel gift) async {
    await _db.insert(
      GIFT_TABLE_NAME,
      gift.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteGift(String id) async {
    await _db.delete(GIFT_TABLE_NAME, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<GiftModel>> getAllGifts() async {
    final result = await _db.query(GIFT_TABLE_NAME);
    return result.map((map) => GiftModel.fromJson(map)).toList();
  }

  @override
  Future<List<GiftModel>> getAllGiftsByEvent(String eventId) async {
    final result = await _db.query(
      GIFT_TABLE_NAME,
      where: 'eventId = ?',
      whereArgs: [eventId],
    );
    return result.map((map) => GiftModel.fromJson(map)).toList();
  }

  @override
  Future<GiftModel?> getGift(String id) async {
    final result =
        await _db.query(GIFT_TABLE_NAME, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? GiftModel.fromJson(result.first) : null;
  }
}
