import 'package:flutter/material.dart';
import 'package:hedeyety/features/auth/data/models/user_model.dart';

import '../../data/datasources/user_repo_local.dart';
import '../../domain/entities/user.dart';

class ProfileProvider with ChangeNotifier {
  List<UserEntity> _profiles = [];
  bool _isLoading = false;

  final UserRepoLocal _repo =
      UserRepoLocal(); // Initialize the local repository

  List<UserEntity> get profiles => _profiles;
  bool get isLoading => _isLoading;

  // Fetch all profiles from the database
  Future<void> fetchProfiles() async {
    _isLoading = true;
    notifyListeners();

    _profiles = await _repo.getALlUsers();
    _isLoading = false;
    notifyListeners();
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
