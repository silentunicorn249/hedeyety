import '../../data/models/gift_model.dart';

abstract class GiftRepository {
  Future<void> initialize(String dbPath);
  Future<void> saveGift(GiftModel gift);
  Future<void> deleteGift(String id);
  Future<List<GiftModel>> getAllGifts();
  Future<List<GiftModel>> getAllGiftsByEvent(String eventId);
  Future<GiftModel?> getGift(String id);
}
