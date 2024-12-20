// A custom widget for displaying event details in a stylish way
import 'package:flutter/material.dart';

class EventListTile extends StatelessWidget {
  final String eventName;
  final String eventDate;
  bool isPublic = true;
  final VoidCallback onTap;

  EventListTile({
    Key? key,
    this.isPublic = true,
    required this.eventName,
    required this.eventDate,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: onTap,
        leading: Icon(
          Icons.event,
          color: Colors.blueAccent,
          size: 40,
        ),
        title: Text(
          eventName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isPublic ? Colors.green[700] : Colors.red[600],
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Colors.grey.shade600,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                eventDate,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}
