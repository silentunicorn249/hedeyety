import 'package:flutter/material.dart';

class PledgedGiftsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Pledged Gifts')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Smartphone for Alice'),
            subtitle: Text('Due: 25th Dec'),
          ),
          ListTile(
            title: Text('Book for Bob'),
            subtitle: Text('Due: 1st Jan'),
          ),
        ],
      ),
    );
  }
}
