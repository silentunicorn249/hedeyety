import 'package:flutter/material.dart';

import '../../../auth/domain/entities/user.dart';
import '../../../events/presentation/screens/events_list_screen.dart';

class FriendTile extends StatelessWidget {
  final UserEntity person;
  final Function onDelete;

  const FriendTile({
    required Key key,
    required this.person,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: ClipOval(
          child: Image.network(
            "https://robohash.org/156.204.121.13.png",
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.person,
                  size: 50); // Fallback if the image fails
            },
          ),
        ),
        title: Text(
          person.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          'Email: ${person.email}',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: () {
            onDelete();
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventsListScreen(
                key: Key("EventsListScreen"),
                userId: person.id,
                name: person.name,
              ),
            ),
          );
        },
      ),
    );
  }
}
