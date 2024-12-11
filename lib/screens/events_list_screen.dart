import 'package:flutter/material.dart';

import '../models/dummy_data.dart';
import '../models/event.dart';
import '../models/user.dart';
import 'gift_list_screen.dart';

class EventsListScreen extends StatefulWidget {
  User person = DummyData.users[0];
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventsListScreen> {
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    events = DummyData.events; // Initialize with person's events
  }

  void _showAddEventModal() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.person.name}\'s Events')),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return ListTile(
            title: Text(event.name),
            subtitle: Text('Date: ${event.date.toLocal()}'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GiftListScreen(),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEventModal();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
