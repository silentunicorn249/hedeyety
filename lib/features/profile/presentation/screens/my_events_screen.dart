import 'package:flutter/material.dart';

import '../../../events/data/datasources/event_repo_local.dart';
import '../../../events/data/models/event_model.dart';
import '../../../events/presentation/widgets/event_tile.dart';
import 'my_event_details.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  _MyEventsScreenState createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  late Future<List<EventModel>> _eventsFuture;
  late List<EventModel> _allEvents = [];
  late List<EventModel> _filteredEvents = [];

  String _sortCriteria = "Date";
  String _filterLocation = "";

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() async {
    final events = await EventRepoLocal().getALlEvents();
    setState(() {
      _allEvents = events;
      _filteredEvents = events;
    });
  }

  void _sortEvents(String criteria) {
    setState(() {
      _sortCriteria = criteria;
      _filteredEvents.sort((a, b) {
        if (criteria == "Date") {
          return a.date.compareTo(b.date);
        } else if (criteria == "Name") {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        }
        return 0;
      });
    });
  }

  void _filterEvents(String location) {
    setState(() {
      _filterLocation = location.toLowerCase();
      _filteredEvents = _allEvents.where((event) {
        return event.location.toLowerCase().contains(_filterLocation);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Sorting and Filtering Controls
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Sort Dropdown
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _sortCriteria,
                    items: ["Date", "Name"]
                        .map((criteria) => DropdownMenuItem(
                              value: criteria,
                              child: Text("Sort by $criteria"),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _sortEvents(value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Filter by Location
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: "Filter by Location",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _filterEvents(value);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Event List
          Expanded(
            child: _filteredEvents.isEmpty
                ? const Center(child: Text("No events found"))
                : ListView.builder(
                    itemCount: _filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = _filteredEvents[index];
                      return EventListTile(
                        eventName: event.name,
                        eventDate: event.date,
                        isPublic: event.isPublic,
                        onTap: () async {
                          // Navigate to MyEventDetailsScreen and wait for a result
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MyEventDetailsScreen(event: event),
                            ),
                          );

                          // If the result indicates an update, reload the events
                          if (result == true) {
                            _loadEvents();
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
