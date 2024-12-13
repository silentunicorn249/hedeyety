abstract class StorageService {
  Future<void> save(String collection, String id, Map<String, dynamic> data);

  Future<Map<String, dynamic>?> fetch(String collection, String id);

  Future<void> delete(String collection, String id);

  Future<List<Map<String, dynamic>>> fetchAll(String collection);
}
