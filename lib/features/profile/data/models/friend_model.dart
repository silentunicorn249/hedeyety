import '../../domain/entities/friend.dart';

class FriendModel extends FriendEntity {
  FriendModel({required super.userId, required super.friendId});

  Map<String, dynamic> toJson() => {
        'userId':
            userId, //TODO if the relation breaks check here (3aref enak hatensa)
        'friendId': friendId,
      };

  factory FriendModel.fromJson(Map<String, dynamic> json) => FriendModel(
        userId: json['userId'],
        friendId: json['friendId'],
      );
}
