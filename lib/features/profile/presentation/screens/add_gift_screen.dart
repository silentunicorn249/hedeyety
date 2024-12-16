import 'package:flutter/material.dart';

class AddGiftScreen extends StatelessWidget {
  final String eventId;

  const AddGiftScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Gift")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Gift Name"),
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Category"),
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Description"),
            ),
          ],
        ),
      ),
    );
  }
}
