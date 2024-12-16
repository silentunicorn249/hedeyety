import '../../domain/entities/gift.dart';

class GiftModel extends GiftEntity {
  GiftModel({
    required super.id,
    required super.name,
    required super.category,
    required super.description,
    required super.price,
    required super.isPledged,
    required super.eventId,
  });

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'description': description,
        'price': price,
        'isPledged': isPledged ? 1 : 0,
        'eventId': eventId, // Store as 0 or 1 in SQLite
      };

  factory GiftModel.fromJson(Map<String, dynamic> json) => GiftModel(
        id: json['id'],
        name: json['name'],
        category: json['category'],
        description: json['description'],
        price: json['price'],
        isPledged: json['isPledged'] == 1,
        eventId: json['eventId'], // Convert 0 or 1 to bool
      );
}
