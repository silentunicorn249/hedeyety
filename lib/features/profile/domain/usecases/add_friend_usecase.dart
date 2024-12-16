import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../../auth/data/datasources/user_repo_remote.dart';
import '../../../auth/data/models/user_model.dart';

final auth = FirebaseAuth.instance;

Future<bool> addFriend(friendNo) async {
  final remote_repo = UserRepoRemote();
  UserModel? user = await remote_repo.getUserByPhoneNo(friendNo);

  debugPrint("addin user ${user?.email}");

  return false;
}
