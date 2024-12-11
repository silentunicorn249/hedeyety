import '../models/storage_interface.dart';
import '../models/user.dart';

class Repository {
  static final Repository _instance = Repository._internal();

  late final StorageService _storageService;

  Repository._internal();

  factory Repository() => _instance;

  // Initialization function
  Future<void> initialize(StorageService storageService) async {
    _storageService = storageService;
  }

  StorageService get storageService => _storageService;

  Future<void> saveUser(User user) async {
    await _storageService.save('users', user.id, user.toJson());
  }

  Future<User?> getUser(String id) async {
    final data = await _storageService.fetch('users', id);
    return data != null ? User.fromJson(data) : null;
  }

  Future<void> deleteUser(String id) async {
    await _storageService.delete('users', id);
  }

  Future<List<User>> getAllUsers() async {
    final data = await _storageService.fetchAll('users');
    return data.map((item) => User.fromJson(item)).toList();
  }
}
