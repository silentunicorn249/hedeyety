import '../../data/models/friend_model.dart';

abstract class FriendRepository {
  Future<void> initialize(String dbName);
  Future<void> saveFriend(FriendModel friend);
  Future<FriendModel?> getFriend(String id);
  Future<void> deleteFriend(String id);
  Future<List<FriendModel>> getALlFriends();
}
