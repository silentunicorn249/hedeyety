import '../features/events/domain/entities/event.dart';
import '../features/gifts/domain/entities/gift.dart';

class EventService {
  List<Event> _dummyEvents = [
    Event(
      id: '1',
      title: 'Alice\'s Birthday',
      date: '2024-12-25',
      gifts: [
        GiftEntity(
            id: '1',
            name: 'Smartphone',
            description: 'iPhone',
            category: 'Electronics'),
      ],
    ),
    Event(
      id: '2',
      title: 'Bob\'s Wedding',
      date: '2025-01-10',
      gifts: [
        GiftEntity(
            id: '2',
            name: 'Flutter Book',
            description: 'Learn Dart & Flutter',
            category: 'Books'),
      ],
    ),
  ];

  // Get all events
  List<Event> getEvents() {
    return _dummyEvents;
  }

  // Fetch a specific event by ID
  Event? getEventById(String id) {
    return _dummyEvents.firstWhere((event) => event.id == id,
        orElse: () => null);
  }

  // Add a new event
  void addEvent(Event event) {
    _dummyEvents.add(event);
  }
}
