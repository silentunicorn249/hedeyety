import 'package:flutter/material.dart';

import '../../../events/data/models/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final bool isChecked; // State of the checkbox
  final void Function(bool? isChecked) onCheckboxChanged;

  const EventCard({
    Key? key,
    required this.event,
    required this.isChecked,
    required this.onCheckboxChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.name,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              event.location,
              style: const TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            const SizedBox(height: 8.0),
            Text(event.desc),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date: ${event.date}',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
                Checkbox(
                  value: isChecked,
                  onChanged: onCheckboxChanged,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
