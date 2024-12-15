class UserEntity {
  String id;
  String name;
  String email;
  String phoneNo;
  Map<String, String> preferences;
  String? profileImage;

  UserEntity(
      {required this.id,
      required this.phoneNo,
      required this.name,
      required this.email,
      required this.preferences});
}
