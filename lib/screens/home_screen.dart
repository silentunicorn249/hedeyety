import 'package:flutter/material.dart';

import '../models/Person.dart';
import '../models/dummy_data.dart';
import 'events_screen.dart';

class HomePage extends StatelessWidget {
  final List<Person> persons = dummyPersons;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hedieaty')),
      body: ListView.builder(
        itemCount: persons.length,
        itemBuilder: (context, index) {
          final person = persons[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(person.profileImage),
            ),
            title: Text(person.name),
            subtitle: Text('Events: ${person.events.length}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventsListScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
