import 'package:flutter/material.dart';
import 'package:hedeyety/models/dummy_data.dart';

import '../models/Person.dart';

class PledgedGiftsScreen extends StatelessWidget {
  Person person = dummyPersons[0];

  @override
  Widget build(BuildContext context) {
    final pledgedGifts =
        person.events.expand((e) => e.gifts).where((g) => g.isPledged).toList();

    return Scaffold(
      appBar: AppBar(title: Text('My Pledged Gifts')),
      body: ListView.builder(
        itemCount: pledgedGifts.length,
        itemBuilder: (context, index) {
          final gift = pledgedGifts[index];
          return ListTile(
            title: Text(gift.name),
            subtitle: Text('Pledged for: ${gift.name}'),
          );
        },
      ),
    );
  }
}
