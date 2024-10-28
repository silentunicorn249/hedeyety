import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hedieaty')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/events'),
            child: Text('Create Your Own Event/List'),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('images/download.jpg'),
                  ),
                  title: Text('Alice Johnson'),
                  subtitle: Text('Upcoming Events: 1'),
                  onTap: () => Navigator.pushNamed(context, '/gifts'),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('images/download.jpg'),
                  ),
                  title: Text('Bob Smith'),
                  subtitle: Text('No Upcoming Events'),
                  onTap: () => Navigator.pushNamed(context, '/gifts'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
