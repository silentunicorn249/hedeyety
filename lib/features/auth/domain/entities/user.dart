class UserEntity {
  String id;
  String name;
  String email;
  Map<String, String> preferences;
  String? profileImage;

  UserEntity(
      {required this.id,
      required this.name,
      required this.email,
      required this.preferences});
}
