import '../../domain/entities/event.dart';

class EventModel extends EventEntity {
  EventModel({
    required super.id,
    required super.name,
    required super.location,
    required super.desc,
    required super.userId,
    required super.date,
    required super.isPublic,
  });

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'location': location,
        'description': desc,
        'userId': userId,
        'date': date,
        'isPublic': isPublic ? 1 : 0, // Store as 0 or 1 in SQLite
      };

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json['id'],
        name: json['name'],
        location: json['location'],
        desc: json['description'],
        userId: json['userId'],
        date: json['date'],
        isPublic: json['isPublic'] == 1, // Convert 0 or 1 to bool
      );
}
