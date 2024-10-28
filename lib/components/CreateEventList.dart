import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateEvent extends StatelessWidget {
  const CreateEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: MaterialButton(
        onPressed: () {
          print("Adding gift");
        },
        child: ListTile(
          leading: Icon(CupertinoIcons.plus),
          title: Text(
            "Create Evenet List",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
