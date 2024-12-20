class GiftEntity {
  String id;
  String name;
  String description;
  String category;
  double price;
  String pledgedId;
  String eventId;
  String? imageUrl;

  GiftEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.pledgedId,
    required this.eventId,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'pledgedId': pledgedId,
      'event_id': eventId,
      'imageUrl': imageUrl,
    };
  }
}
