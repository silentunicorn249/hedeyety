import 'package:hedeyety/features/auth/domain/entities/user.dart';

class UserModel extends UserEntity {
  UserModel(
      {required super.id,
      required super.name,
      required super.email,
      required super.preferences,
      required super.phoneNo});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phoneNo': phoneNo,
        'preferences': preferences.toString(),
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNo: json["phoneNo"],
      preferences: (json['preferences'] is Map<String, dynamic>)
          ? Map<String, String>.from(json['preferences'])
          : {} // Fallback to empty map if it's not a valid Map
      );
}
