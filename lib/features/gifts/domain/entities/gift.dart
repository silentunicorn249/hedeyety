class Gift {
  int? id;
  String name;
  String description;
  String? category;
  double? price;
  bool isPledged;
  int eventId;

  Gift({
    this.id,
    required this.name,
    required this.description,
    this.category,
    this.price,
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
