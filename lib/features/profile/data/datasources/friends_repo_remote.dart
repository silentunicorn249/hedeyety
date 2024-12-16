import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../../auth/data/models/user_model.dart';
import '../../data/models/friend_model.dart';
import '../../domain/repository/friend_repository.dart';

class FriendRepoRemote implements FriendRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save a friend relation in Firestore
  @override
  Future<bool> saveFriend(FriendModel friend) async {
    try {
      debugPrint("Saving biderectional ${friend.userId} ${friend.friendId}");
      // Save the original relationship
      String docId1 = '${friend.userId}_${friend.friendId}';
      await _firestore.collection('friends').doc(docId1).set(friend.toJson());
      debugPrint("Saved first");
      // Save the reverse relationship
      String docId2 = '${friend.friendId}_${friend.userId}';
      await _firestore.collection('friends').doc(docId2).set({
        'userId': friend.friendId,
        'friendId': friend.userId,
      });
      debugPrint("Saved second");

      print("Friendship saved for both directions: $docId1 and $docId2");
      return true;
    } catch (e) {
      print("Error saving friendship: $e");
      return false;
    }
  }

  // Get a specific friend document by its unique ID
  @override
  Future<FriendModel?> getFriend(String id) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('friends').doc(id).get();

      if (snapshot.exists) {
        return FriendModel.fromJson(snapshot.data() as Map<String, dynamic>);
      } else {
        print("No friend found for ID: $id");
        return null;
      }
    } catch (e) {
      print("Error fetching friend: $e");
      return null;
    }
  }

  // Delete a friend document
  @override
  Future<void> deleteFriend(String id) async {
    try {
      await _firestore.collection('friends').doc(id).delete();
      print("Friend deleted: $id");
    } catch (e) {
      print("Error deleting friend: $e");
      throw Exception("Error deleting friend: $e");
    }
  }

  Future<List<UserModel>> getFriendsAsUsers(String userId) async {
    try {
      // Step 1: Fetch friends where userId matches
      QuerySnapshot friendSnapshot = await _firestore
          .collection('friends')
          .where('userId', isEqualTo: userId)
          .get();

      // Step 2: Extract friend IDs, handle null safely
      List<String> friendIds = friendSnapshot.docs
          .map((doc) {
            final data =
                doc.data() as Map<String, dynamic>?; // Safely cast to Map
            return data?['friendId'] as String?; // Safely access 'friendId'
          })
          .whereType<String>() // Remove any null values from the list
          .toList();

      if (friendIds.isEmpty) return [];

      // Step 3: Use whereIn to batch fetch user documents
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: friendIds)
          .get();

      // Step 4: Convert user documents to UserModel
      List<UserModel> friends = userSnapshot.docs
          .map((doc) {
            final data =
                doc.data() as Map<String, dynamic>?; // Safely cast to Map
            return data != null ? UserModel.fromJson(data) : null;
          })
          .whereType<UserModel>() // Remove any null values from the list
          .toList();

      return friends;
    } catch (e) {
      print("Error fetching friends as users: $e");
      return [];
    }
  }

  Future<List<FriendModel>> getFriendsByUserId(String userId) async {
    try {
      // Query friends where userId is either the userId or the friendId
      QuerySnapshot snapshot = await _firestore
          .collection('friends')
          .where('userId', isEqualTo: userId)
          .get();

      QuerySnapshot reverseSnapshot = await _firestore
          .collection('friends')
          .where('friendId', isEqualTo: userId)
          .get();

      // Combine results from both queries
      List<FriendModel> friends = snapshot.docs
          .map(
              (doc) => FriendModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      friends.addAll(reverseSnapshot.docs
          .map(
              (doc) => FriendModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList());

      return friends;
    } catch (e) {
      print("Error fetching friends for userId: $e");
      return [];
    }
  }

  // Get all friend documents (useful for admin purposes)
  @override
  Future<List<FriendModel>> getALlFriends() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('friends').get();
      return snapshot.docs
          .map(
              (doc) => FriendModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching all friends: $e");
      return [];
    }
  }

  @override
  Future<void> initialize(String dbName) async {}
}
