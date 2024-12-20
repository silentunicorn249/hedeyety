import '../../domain/entities/gift.dart';

class GiftModel extends GiftEntity {
  GiftModel({
    required super.id,
    required super.name,
    required super.category,
    required super.description,
    required super.price,
    required super.pledgedId,
    required super.eventId,
    required super.imageUrl,
  });

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'description': description,
        'price': price,
        'pledgedId': pledgedId,
        'eventId': eventId,
        'imageUrl': imageUrl,
      };

  factory GiftModel.fromJson(Map<String, dynamic> json) => GiftModel(
        id: json['id'],
        name: json['name'],
        category: json['category'],
        description: json['description'],
        price: json['price'],
        pledgedId: json['pledgedId'],
        eventId: json['eventId'],
        imageUrl: json['imageUrl'],
      );
}
