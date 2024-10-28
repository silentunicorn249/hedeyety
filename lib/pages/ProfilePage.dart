import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Profile')),
      body: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('images/download.jpg'),
          ),
          ListTile(
            title: Text('Mark Johnson'),
            subtitle: Text('Edit Profile Info'),
            onTap: () {
              // Edit profile logic
            },
          ),
          ListTile(
            title: Text('My Pledged Gifts'),
            onTap: () => Navigator.pushNamed(context, '/pledged-gifts'),
          ),
        ],
      ),
    );
  }
}
