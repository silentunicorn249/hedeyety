import 'event.dart';
import 'gift.dart';
import 'notification.dart';
import 'pledge.dart';
import 'user.dart';

class DummyData {
  static List<UserModel> users = [
    UserModel(
      id: 1,
      name: 'Alice',
      email: 'alice@example.com',
      preferences: {"mode": "Dark"},
    ),
    UserModel(
      id: 2,
      name: 'Alice2',
      email: 'alice@example.com',
      preferences: {"mode": "Dark"},
    ),
    UserModel(
      id: 3,
      name: 'Alice3',
      email: 'alice@example.com',
      preferences: {"mode": "Dark"},
    ),
  ];

  static List<Event> events = [
    Event(
      id: 'e1',
      userId: 'u1',
      name: 'Alice\'s Birthday',
      date: DateTime(2024, 5, 12),
      location: 'Alice\'s Home',
      description: 'Birthday Party',
    ),
    Event(
      id: 'e2',
      userId: 'u2',
      name: 'Company Outing',
      date: DateTime(2024, 6, 20),
      location: 'Beach Resort',
      description: 'Team building event',
    ),
    Event(
      id: 'e3',
      userId: 'u2',
      name: 'Camping Adventure',
      date: DateTime(2024, 7, 25),
      location: 'National Park',
      description: 'Weekend camping trip',
    ),
  ];

  static List<Gift> gifts = [
    Gift(
      id: 3,
      name: 'Smartphone',
      description: 'Latest model',
      category: 'Electronics',
      price: 699.99,
      isPledged: true,
      eventId: 1,
    ),
    Gift(
      id: 3,
      name: 'Smartphone',
      description: 'Latest model',
      category: 'Electronics',
      price: 699.99,
      isPledged: false,
      eventId: 1,
    ),
  ];

  static List<Pledge> pledges = [
    Pledge(
        id: 'p1',
        userId: 'u2',
        giftId: 'g1',
        pledgeDate: DateTime(2024, 4, 10)),
    Pledge(
        id: 'p2',
        userId: 'u3',
        giftId: 'g4',
        pledgeDate: DateTime(2024, 6, 15)),
  ];

  static List<Notification> notifications = [
    Notification(
        id: 'n1',
        type: 'pledge',
        userId: 'u1',
        message: 'Bob pledged to buy Smartphone.',
        timestamp: DateTime.now()),
    Notification(
        id: 'n2',
        type: 'pledge',
        userId: 'u3',
        message: 'Charlie pledged to buy Tent.',
        timestamp: DateTime.now()),
  ];
}
