import '../features/gifts/domain/entities/gift.dart';

class GiftService {
  List<Gift> _dummyGifts = [
    Gift(
        id: '1',
        name: 'Smartphone',
        description: 'Latest iPhone',
        category: 'Electronics'),
    Gift(
        id: '2',
        name: 'Flutter Book',
        description: 'Learn Flutter',
        category: 'Books'),
  ];

  // Simulate fetching all gifts asynchronously
  Future<List<Gift>> getGifts() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return _dummyGifts;
  }

  // Simulate toggling gift status
  Future<void> toggleGiftStatus(String id) async {
    var gift = _dummyGifts.firstWhere((g) => g.id == id);
    gift.isPledged = !gift.isPledged;
  }
}
