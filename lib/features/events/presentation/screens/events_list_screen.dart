import 'package:flutter/material.dart';
import 'package:hedeyety/features/events/data/datasources/event_repo_remote.dart';
import 'package:hedeyety/features/events/data/models/event_model.dart';

import '../../../profile/presentation/screens/my_event_details.dart';
import '../widgets/event_tile.dart';

class EventsListScreen extends StatelessWidget {
  final String userId;
  final String name;
  final remoteRepo = EventRepoRemote();

  EventsListScreen({super.key, required this.userId, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$name\'s Events')),
      body: FutureBuilder<List<EventModel>>(
        future: remoteRepo.getEventsByUserId(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final events = snapshot.data!;
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return EventListTile(
                  key: Key("EventListTile$index"),
                  eventName: event.name,
                  eventDate: event.date,
                  onTap: () {
                    // Navigate to event details screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyEventDetailsScreen(
                            key: Key("MyEventDetailsScreen"), event: event),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No events found.'));
          }
        },
      ),
    );
  }
}
