import 'package:flutter/material.dart';
import 'package:hedeyety/features/auth/data/models/user_model.dart';

import '../../data/datasources/user_repo_local.dart';
import '../../domain/entities/user.dart';

class ProfileProvider with ChangeNotifier {
  List<UserEntity> _profiles = [];
  bool _isLoading = false;
  bool _isInitialized = false; // Prevent multiple fetch calls

  final UserRepoLocal _repo = UserRepoLocal(); // Local repository instance

  List<UserEntity> get profiles => _profiles;
  bool get isLoading => _isLoading;

  // Constructor to initialize profiles
  ProfileProvider() {
    initializeProfiles(); // Trigger data fetching
  }

  // Public method to allow initialization when needed
  Future<void> initializeProfiles() async {
    if (_isInitialized) return; // Prevent re-fetching if already initialized
    _isInitialized = true;

    _isLoading = true;
    notifyListeners();

    try {
      _profiles = await _repo.getALlUsers();
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
    await _repo.saveUser(user); // Save to database
    _profiles.add(user); // Add to local list
    notifyListeners();
  }

  // Delete a user and sync with the database
  Future<void> deleteUser(String userId) async {
    await _repo.deleteUser(userId); // Remove from database
    _profiles
        .removeWhere((user) => user.id == userId); // Remove from local list
    notifyListeners();
  }
}
