class UserModel {
  int id;
  String name;
  String email;
  Map<String, dynamic> preferences;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.preferences});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'preferences': preferences.toString(),
      };
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        preferences: Map<String, dynamic>.from(json['preferences']),
      );
}
