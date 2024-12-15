import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/models/user_model.dart';
import '../../domain/repository/user_repository.dart';

class UserRepoRemote implements UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initialize Firestore (Firebase already initialized in main.dart)
  @override
  Future<void> initialize(String dbName) async {
    // Firebase initialization is typically done in main.dart so no action here.
    // If needed, you can configure Firestore or prepare the database here.
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      // Save the user to the Firestore collection
      await _firestore.collection('users').doc(user.id).set(user.toJson());
      print("User saved: ${user.id}");
    } catch (e) {
      print("Error saving user: $e");
      throw Exception("Error saving user: $e");
    }
  }

  @override
  Future<UserModel?> getUser(String id) async {
    try {
      print("Fetching");
      // Fetch the user data from Firestore by user ID
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(id).get();

      // If the document exists, return its data
      if (snapshot.exists) {
        var userDoc = snapshot.data();
        print(userDoc);
        return UserModel.fromJson(userDoc as Map<String, dynamic>);
      } else {
        // If the user is not found, return null
        return null;
      }
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      // Delete the user from Firestore
      await _firestore.collection('users').doc(id).delete();
      print("User deleted: $id");
    } catch (e) {
      print("Error deleting user: $e");
      throw Exception("Error deleting user: $e");
    }
  }

  @override
  Future<List<UserModel>> getALlUsers() async {
    try {
      // Fetch all users from Firestore
      QuerySnapshot snapshot = await _firestore.collection('users').get();

      // Map the query result to a list of UserModel objects
      List<UserModel> users = snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return users;
    } catch (e) {
      print("Error fetching all users: $e");
      return [];
    }
  }

  Future<UserModel?> getUserByName(String name) async {
    try {
      print("Fetching $name");
      // Query Firestore for the user with the matching name
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('name', isEqualTo: name)
          .get();

      // Check if any user is found with the specified name
      if (snapshot.docs.isNotEmpty) {
        // Map the first matching document to a UserModel
        var userDoc = snapshot.docs.first;
        return UserModel.fromJson(
            {"id": userDoc.id, ...userDoc.data() as Map<String, dynamic>});
      } else {
        // If no user is found with that name, return null
        print("No user found");
        return null;
      }
    } catch (e) {
      print("Error fetching user by name: $e");
      return null;
    }
  }

  Future<UserModel?> getUserByPhoneNo(String phoneNo) async {
    try {
      print("Fetching $phoneNo by phoneNo");
      // Query Firestore for the user with the matching name
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('phoneNo', isEqualTo: phoneNo)
          .get();

      // Check if any user is found with the specified name
      if (snapshot.docs.isNotEmpty) {
        // Map the first matching document to a UserModel
        var userDoc = snapshot.docs.first;
        return UserModel.fromJson(
            {"id": userDoc.id, ...userDoc.data() as Map<String, dynamic>});
      } else {
        // If no user is found with that name, return null
        print("No user found");
        return null;
      }
    } catch (e) {
      print("Error fetching user by name: $e");
      return null;
    }
  }
}
