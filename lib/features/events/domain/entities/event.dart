class EventEntity {
  String id;
  String name;
  String location;
  String desc;
  String userId;
  String date;
  bool isPublic;

  EventEntity({
    required this.id,
    required this.desc,
    required this.name,
    required this.location,
    required this.userId,
    required this.date,
    required this.isPublic,
  });
}
