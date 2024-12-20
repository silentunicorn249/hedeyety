import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedeyety/features/auth/data/datasources/user_repo_remote.dart';
import 'package:hedeyety/features/profile/data/datasources/friends_repo_remote.dart';
import 'package:hedeyety/features/profile/data/models/friend_model.dart';
import 'package:provider/provider.dart';

import '../../../auth/data/models/user_model.dart';
import '../../../events/presentation/providers/friends_provider.dart';

class AddFriendScreen extends StatelessWidget {
  String friendNo = "";
  final userId = FirebaseAuth.instance.currentUser!.uid;

  AddFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff757575),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Add Friend",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.lightBlueAccent),
              ),
              TextField(
                key: const Key("phoneNoTextField"),
                autofocus: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  friendNo = value;
                },
              ),
              MaterialButton(
                key: const Key("addFriendButton"),
                color: Colors.lightBlueAccent,
                onPressed: () async {
                  final friendsProvider =
                      Provider.of<FriendsProvider>(context, listen: false);

                  final remote_repo = UserRepoRemote();
                  UserModel? user =
                      await remote_repo.getUserByPhoneNo(friendNo);

                  print(user?.email);
                  if (user != null) {
                    debugPrint("${user.id} == $userId");
                    print(user.id == userId);
                    if (user.id == userId) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Cannot add yourself, LOL!!!")));
                      Navigator.pop(context);
                      return;
                    }
                    final friends_repo = FriendRepoRemote();
                    bool succ = await friends_repo.saveFriend(
                        FriendModel(userId: userId, friendId: user.id));
                    friendsProvider.addUser(user);
                    debugPrint("Added success");
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("No user found")));
                  }
                  Navigator.pop(context);
                },
                child: const Text(
                  "Add",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
