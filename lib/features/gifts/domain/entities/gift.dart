class GiftEntity {
  String id;
  String name;
  String description;
  String category;
  double price;
  bool isPledged;
  String eventId;

  GiftEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.isPledged,
    required this.eventId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'status': isPledged,
      'event_id': eventId,
    };
  }
}
