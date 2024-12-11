class Pledge {
  final String id;
  final String userId;
  final String giftId;
  final DateTime pledgeDate;

  Pledge({
    required this.id,
    required this.userId,
    required this.giftId,
    required this.pledgeDate,
  });

  factory Pledge.fromMap(Map<String, dynamic> map) {
    return Pledge(
      id: map['id'],
      userId: map['userId'],
      giftId: map['giftId'],
      pledgeDate: DateTime.parse(map['pledgeDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'giftId': giftId,
      'pledgeDate': pledgeDate.toIso8601String(),
    };
  }
}
