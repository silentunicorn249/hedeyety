import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/gift_repository.dart';
import '../models/gift_model.dart';

class GiftRepoRemote implements GiftRepository {
  static final GiftRepoRemote _instance = GiftRepoRemote._();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String GIFT_COLLECTION_NAME = "gifts";

  GiftRepoRemote._();

  factory GiftRepoRemote() => _instance;

  @override
  Future<void> initialize(String dbPath) async {
    // Firebase doesn't need explicit initialization in most cases.
  }

  @override
  Future<void> saveGift(GiftModel gift) async {
    await _firestore
        .collection(GIFT_COLLECTION_NAME)
        .doc(gift.id)
        .set(gift.toJson());
  }

  @override
  Future<void> deleteGift(String id) async {
    await _firestore.collection(GIFT_COLLECTION_NAME).doc(id).delete();
  }

  @override
  Future<List<GiftModel>> getAllGifts() async {
    final snapshot = await _firestore.collection(GIFT_COLLECTION_NAME).get();
    return snapshot.docs.map((doc) => GiftModel.fromJson(doc.data())).toList();
  }

  @override
  Future<List<GiftModel>> getAllGiftsByEvent(String eventId) async {
    final snapshot = await _firestore
        .collection(GIFT_COLLECTION_NAME)
        .where('eventId', isEqualTo: eventId)
        .get();
    return snapshot.docs.map((doc) => GiftModel.fromJson(doc.data())).toList();
  }

  @override
  Future<GiftModel?> getGift(String id) async {
    final snapshot =
        await _firestore.collection(GIFT_COLLECTION_NAME).doc(id).get();
    return snapshot.exists ? GiftModel.fromJson(snapshot.data()!) : null;
  }
}
