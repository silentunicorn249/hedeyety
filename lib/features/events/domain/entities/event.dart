class Event {
  String id;
  String name;
  DateTime date;
  String location;
  String description;
  String userId;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.description,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'date': date.toIso8601String(),
        'location': location,
        'description': description,
        'userId': userId,
      };

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json['id'],
        name: json['name'],
        date: DateTime.parse(json['date']),
        location: json['location'],
        description: json['description'],
        userId: json['userId'],
      );
}
