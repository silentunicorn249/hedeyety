import '../../data/models/event_model.dart';

abstract class EventRepository {
  Future<void> initialize(String dbName);
  Future<void> saveEvent(EventModel event);
  Future<EventModel?> getEvent(String id);
  Future<void> deleteEvent(String id);
  Future<List<EventModel>> getALlEvents();
}
