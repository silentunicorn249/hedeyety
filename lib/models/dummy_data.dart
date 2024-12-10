import 'Event.dart';
import 'Gift.dart';
import 'Person.dart';

final List<Person> dummyPersons = [
  Person(
    name: 'Alice Johnsonn',
    profileImage: 'https://loremflickr.com/150/150?random=1',
    events: [
      Event(
        title: 'Birthday Party',
        date: DateTime(2024, 12, 25),
        gifts: [
          Gift(
            name: 'Smartphone',
            description: 'A new smartphone',
            category: 'Electroniccs',
            isPledged: true,
            price: 100.0,
          ),
          Gift(
            name: 'Book',
            description: 'A book on Flutter',
            category: 'Books',
            price: 110,
          ),
        ],
      ),
    ],
  ),
  Person(
    name: 'Alice Johnson',
    profileImage: 'https://loremflickr.com/150/150?random=1',
    events: [
      Event(
        title: 'Birthday Party',
        date: DateTime(2024, 12, 25),
        gifts: [
          Gift(
            name: 'Smartphone',
            description: 'A new smartphone',
            category: 'Electronics',
            isPledged: true,
            price: 100,
          ),
          Gift(
            name: 'Book',
            description: 'A book on Flutter',
            category: 'Books',
            price: 110,
          ),
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
