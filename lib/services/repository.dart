import '../features/auth/domain/entities/user.dart';
import 'storage_interface.dart';

class Repositoryy {
  static final Repository _instance = Repository._internal();

  late final StorageService _storageService;

  Repository._internal();

  factory Repository() => _instance;

  // Initialization function
  Future<void> initialize(StorageService storageService) async {
    _storageService = storageService;
  }

  StorageService get storageService => _storageService;

  Future<void> saveUser(UserEntity user) async {
    await _storageService.save('users', user.id, user.toJson());
  }

  Future<UserEntity?> getUser(String id) async {
    final data = await _storageService.fetch('users', id);
    return data != null ? UserEntity.fromJson(data) : null;
  }

  Future<void> deleteUser(String id) async {
    await _storageService.delete('users', id);
  }

  Future<List<UserEntity>> getAllUsers() async {
    final data = await _storageService.fetchAll('users');
    return data.map((item) => UserEntity.fromJson(item)).toList();
  }
}
