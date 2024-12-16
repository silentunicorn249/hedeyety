import 'package:flutter/material.dart';
import 'package:hedeyety/features/auth/data/models/user_model.dart';
import 'package:hedeyety/features/profile/data/datasources/friends_repo_remote.dart';

import '../../../auth/data/datasources/user_repo_local.dart';
import '../../../auth/domain/entities/user.dart';

class FriendsProvider with ChangeNotifier {
  List<UserEntity> _profiles = [];
  bool _isLoading = false;

  final UserRepoLocal _local_repo =
      UserRepoLocal(); // Local repository instance
  final FriendRepoRemote _remote_repo =
      FriendRepoRemote(); // Local repository instance

  List<UserEntity> get profiles => _profiles;

  bool get isLoading => _isLoading;

  // Constructor to initialize profiles
  FriendsProvider() {
    initializeProfiles(); // Trigger data fetching
  }

  // Public method to allow initialization when needed
  Future<void> initializeProfiles() async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint("FriendsProvider fetch");
      final remote_friends = await _remote_repo.getALlFriends();
      if (remote_friends.length > 0) {
        print(remote_friends.first.friendId);
        print(remote_friends.first.userId);
      }
      _profiles = await _local_repo.getALlUsers();
      print(profiles.first?.email);
    } catch (e) {
      // Handle errors, optionally log them
      debugPrint('Error fetching profiles: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a user and sync with the database
  Future<void> addUser(UserModel user) async {
    await _local_repo.saveUser(user); // Save to database
    _profiles.add(user); // Add to local list
    notifyListeners();
  }

  // Delete a user and sync with the database
  Future<void> deleteUser(String userId) async {
    await _remote_repo.deleteFriend(userId);
    await _local_repo.deleteUser(userId); // Remove from database
    _profiles
        .removeWhere((user) => user.id == userId); // Remove from local list
    notifyListeners();
  }
}
