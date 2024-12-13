import 'package:flutter/material.dart';
import 'package:hedeyety/features/auth/data/datasources/user_repo_local.dart';

import '../../../auth/data/models/user_model.dart';

class AddFriendScreen extends StatelessWidget {
  String friendName = "";
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
                  friendName = value;
                },
              ),
              MaterialButton(
                color: Colors.lightBlueAccent,
                onPressed: () async {
                  final repo = await UserRepoLocal.create();
                  await repo.saveUser(UserModel(
                      id: "u1",
                      name: friendName,
                      email: "awMail",
                      preferences: {}));
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
