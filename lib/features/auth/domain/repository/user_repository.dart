import '../../data/models/user_model.dart';

abstract class UserRepository {
  Future<void> initialize(String dbName);
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser(String id);
  Future<void> deleteUser(String id);
  Future<List<UserModel>> getALlUsers();
}
