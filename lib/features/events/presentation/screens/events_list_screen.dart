import 'package:flutter/material.dart';
import 'package:hedeyety/features/events/data/datasources/event_repo_remote.dart';
import 'package:hedeyety/features/events/data/models/event_model.dart';

import '../../../gifts/presentation/screens/gift_list_screen.dart';

class EventsListScreen extends StatelessWidget {
  final String userId;
  final String name;
  final remoteRepo = EventRepoRemote();
  EventsListScreen({required this.userId, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$name\'s Events')),
      body: FutureBuilder<List<EventModel>>(
        future: remoteRepo.getEventsByUserId(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final events = snapshot.data!;
            return ListView.builder(
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
            );
          } else {
            return Center(child: Text('No events found.'));
          }
        },
      ),
    );
  }
}
