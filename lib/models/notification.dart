class Notification {
  final String id;
  final String type;
  final String userId;
  final String message;
  final DateTime timestamp;

  Notification({
    required this.id,
    required this.type,
    required this.userId,
    required this.message,
    required this.timestamp,
  });

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      id: map['id'],
      type: map['type'],
      userId: map['userId'],
      message: map['message'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'userId': userId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
