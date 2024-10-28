import 'package:flutter/material.dart';

class EventListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Events')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // Add new event logic here
            },
            child: Text('Add New Event'),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text('Birthday Party'),
                  subtitle: Text('Upcoming'),
                  onTap: () => Navigator.pushNamed(context, '/gifts'),
                ),
                ListTile(
                  title: Text('Wedding Gift List'),
                  subtitle: Text('Current'),
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
