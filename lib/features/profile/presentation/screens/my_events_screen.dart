import 'package:flutter/material.dart';
import 'package:hedeyety/features/events/data/datasources/event_repo_remote.dart';

import '../../../events/data/datasources/event_repo_local.dart';
import '../../../events/data/models/event_model.dart';
import 'my_event_details.dart';

class MyEventsScreen extends StatefulWidget {
  @override
  _MyEventsScreenState createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  late Future<List<EventModel>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() {
    _eventsFuture = EventRepoLocal().getALlEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<EventModel>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading events"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No events found"));
          }

          final events = snapshot.data!;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                child: ListTile(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MyEventDetailsScreen(event: event),
                      ),
                    );
                  },
                  title: Text(event.name),
                  subtitle: Text("${event.location} - ${event.date}"),
                  trailing: Checkbox(
                    value: event.isPublic,
                    onChanged: (bool? newValue) async {
                      if (newValue!) {
                        await EventRepoLocal()
                            .updateEventPrivateFlag(event.id, newValue);
                        await EventRepoRemote().saveEvent(event);
                        setState(() {
                          event.isPublic = newValue;
                        });
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
