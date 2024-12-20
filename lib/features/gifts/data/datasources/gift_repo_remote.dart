import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/repositories/gift_repository.dart';
import '../models/gift_model.dart';

class GiftRepoRemote implements GiftRepository {
  static final GiftRepoRemote _instance = GiftRepoRemote._();
  final userId = FirebaseAuth.instance.currentUser!.uid;
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
    debugPrint("Saving gift remotely");
    await _firestore
        .collection(GIFT_COLLECTION_NAME)
        .doc(gift.id)
        .set(gift.toJson());
    debugPrint("Saveddd");
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

  Future<List<GiftModel>> getAllPledgedGifts() async {
    try {
      // Here you can use Firebase or an API call to fetch data
      // For the purpose of this example, assume we have a remote API or Firebase query to get the gifts

      final gifts = await getAllGifts(); // Placeholder for the actual API call
      return gifts.where((gift) {
        debugPrint("${gift.name}:  ${gift.pledgedId} > ${userId}");
        return gift.pledgedId == userId;
      }).toList(); // Only return pledged gifts
    } catch (e) {
      throw Exception('Failed to load pledged gifts: $e');
    }
  }

  Future<void> updateGiftPledgedStatus(String giftId, String pledgedId,
      String giftOwnerId, String title, String message) async {
    final notification = {
      'title': title,
      'body': message,
    };

    // Update the gift's pledged status
    await _firestore.collection(GIFT_COLLECTION_NAME).doc(giftId).update({
      'pledgedId': pledgedId,
    });

    // Append the notification to the gift owner's notifications array
    final notificationsRef =
        _firestore.collection('notifications').doc(giftOwnerId);

    await notificationsRef.set({
      'notifications': FieldValue.arrayUnion([notification]),
    }, SetOptions(merge: true));
  }
}
