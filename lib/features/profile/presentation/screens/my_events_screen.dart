import 'package:flutter/material.dart';
import 'package:hedeyety/features/events/data/datasources/event_repo_remote.dart';

import '../../../events/data/datasources/event_repo_local.dart';
import '../../../events/data/models/event_model.dart';

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
        title: Text("Events"),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<EventModel>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading events"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No events found"));
          }

          final events = snapshot.data!;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                child: ListTile(
                  onTap: () {},
                  title: Text(event.name),
                  subtitle: Text(event.location),
                  trailing: Checkbox(
                    value: event.isPublic,
                    onChanged: (bool? newValue) async {
                      if (newValue!) {
                        setState(() {
                          event.isPublic = newValue;
                        });
                        await EventRepoLocal()
                            .updateEventPrivateFlag(event.id, newValue);
                        await EventRepoRemote().saveEvent(event);
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
