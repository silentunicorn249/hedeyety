import 'Event.dart';
import 'Gift.dart';
import 'Person.dart';

final List<Person> dummyPersons = [
  Person(
    name: 'Alice Johnson',
    profileImage: 'https://via.placeholder.com/150',
    events: [
      Event(
        title: 'Birthday Party',
        date: DateTime(2024, 12, 25),
        gifts: [
          Gift(
              name: 'Smartphone',
              description: 'A new smartphone',
              category: 'Electronics',
              isPledged: true),
          Gift(
              name: 'Book',
              description: 'A book on Flutter',
              category: 'Books'),
        ],
      ),
    ],
  ),
  Person(
    name: 'Bob Smith',
    profileImage: 'https://via.placeholder.com/150',
    events: [],
  ),
];
