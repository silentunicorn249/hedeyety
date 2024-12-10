import 'package:flutter/material.dart';

import '../models/Event.dart';
import '../models/Person.dart';
import '../models/dummy_data.dart';
import 'gift_list_screen.dart';

class EventListScreen extends StatefulWidget {
  Person person = dummyPersons[0];

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    events = widget.person.events; // Initialize with person's events
  }

  void _addNewEvent(String title, DateTime date) {
    setState(() {
      events.add(Event(title: title, date: date, gifts: []));
    });
    Navigator.pop(context); // Close the modal
  }

  void _showAddEventModal() {
    String newTitle = '';
    DateTime newDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow full-screen modal scroll
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          // Adjust padding based on keyboard visibility
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Adjust size based on content
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Event Title'),
                  onChanged: (value) => newTitle = value,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _addNewEvent(newTitle, newDate); // Add event logic
                  },
                  child: Text('Add Event'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.person.name}\'s Events')),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return ListTile(
            title: Text(event.title),
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
