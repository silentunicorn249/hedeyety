class Friend {
  int userId;
  int friendId;

  Friend({required this.userId, required this.friendId});

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'friend_id': friendId,
    };
  }
}
