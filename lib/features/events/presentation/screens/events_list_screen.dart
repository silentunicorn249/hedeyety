import 'package:flutter/material.dart';
import 'package:hedeyety/features/events/data/models/event_model.dart';

import '../../../gifts/presentation/screens/gift_list_screen.dart';

class EventsListScreen extends StatelessWidget {
  late String userId;
  late String name;
  EventsListScreen({required this.userId, required this.name});

  List<EventModel> events = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${name}\'s Events')),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return ListTile(
            title: Text(event.name),
            subtitle: Text('Desc: ${event.date}'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GiftListScreen(),
              ),
            ),
          );
        },
      ),
    );
  }
}
