import 'package:flutter/material.dart';
import 'package:hedeyety/features/auth/data/datasources/user_repo_remote.dart';
import 'package:provider/provider.dart';

import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/providers/profile_provider.dart';

class AddFriendScreen extends StatelessWidget {
  String friendNo = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
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
                autofocus: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  friendNo = value;
                },
              ),
              MaterialButton(
                color: Colors.lightBlueAccent,
                onPressed: () async {
                  final profileProvider =
                      Provider.of<ProfileProvider>(context, listen: false);
                  final remote_repo = UserRepoRemote();
                  UserModel? user = await remote_repo.getUser(friendNo);

                  print(user?.email);
                  if (user != null) {
                    profileProvider.addUser(user);
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("No user found")));
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
