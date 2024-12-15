import '../../domain/entities/event.dart';

class EventModel extends EventEntity {
  EventModel(
      {required super.id,
      required super.name,
      required super.location,
      required super.desc,
      required super.userId,
      required super.date});

  Map<String, dynamic> toJson() => {
        'id': id, //TODO if the relation breaks check here (3aref enak hatensa)
        'name': name,
        'email': location,
        'phoneNo': desc,
        'userId': userId,
      };

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      desc: json["phoneNo"],
      userId: json["userId"],
      date: json['date']);
}
