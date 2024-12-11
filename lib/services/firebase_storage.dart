class FirebaseService implements StorageService {
  static final FirebaseService _instance = FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseService._internal();

  factory FirebaseService() => _instance;

  @override
  Future<void> save(
      String collection, String id, Map<String, dynamic> data) async {
    await _firestore.collection(collection).doc(id).set(data);
  }

  @override
  Future<Map<String, dynamic>?> fetch(String collection, String id) async {
    final doc = await _firestore.collection(collection).doc(id).get();
    return doc.exists ? doc.data() : null;
  }

  @override
  Future<void> delete(String collection, String id) async {
    await _firestore.collection(collection).doc(id).delete();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAll(String collection) async {
    final querySnapshot = await _firestore.collection(collection).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }
}
