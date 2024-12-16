import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/models/event_model.dart';
import '../../domain/repository/event_repository.dart';

class EventRepoRemote implements EventRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initialize Firestore (Firebase already initialized in main.dart)
  @override
  Future<void> initialize(String dbName) async {
    // Firebase initialization is typically done in main.dart so no action here.
    // If needed, you can configure Firestore or prepare the database here.
  }

  @override
  Future<void> saveEvent(EventModel event) async {
    try {
      // Save the event to the Firestore collection
      await _firestore.collection('events').doc(event.id).set(event.toJson());
      print("Event saved: ${event.id}");
    } catch (e) {
      print("Error saving event: $e");
      throw Exception("Error saving event: $e");
    }
  }

  @override
  Future<EventModel?> getEvent(String id) async {
    try {
      print("Fetchig");
      // Fetch the event data from Firestore by event ID
      DocumentSnapshot snapshot =
          await _firestore.collection('events').doc(id).get();

      // If the document exists, return its data
      if (snapshot.exists) {
        var eventDoc = snapshot.data();
        print(eventDoc);
        return EventModel.fromJson(eventDoc as Map<String, dynamic>);
      } else {
        // If the event is not found, return null
        return null;
      }
    } catch (e) {
      print("Error fetching event: $e");
      return null;
    }
  }

  @override
  Future<void> deleteEvent(String id) async {
    try {
      // Delete the event from Firestore
      await _firestore.collection('events').doc(id).delete();
      print("Event deleted: $id");
    } catch (e) {
      print("Error deleting event: $e");
      throw Exception("Error deleting event: $e");
    }
  }

  @override
  Future<List<EventModel>> getALlEvents() async {
    try {
      // Fetch all events from Firestore
      QuerySnapshot snapshot = await _firestore.collection('events').get();

      // Map the query result to a list of EventModel objects
      List<EventModel> events = snapshot.docs
          .map((doc) => EventModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return events;
    } catch (e) {
      print("Error fetching all events: $e");
      return [];
    }
  }

  Future<EventModel?> getEventByName(String name) async {
    try {
      print("Fetching $name");
      // Query Firestore for the event with the matching name
      QuerySnapshot snapshot = await _firestore
          .collection('events')
          .where('name', isEqualTo: name)
          .get();

      // Check if any event is found with the specified name
      if (snapshot.docs.isNotEmpty) {
        // Map the first matching document to a EventModel
        var eventDoc = snapshot.docs.first;
        return EventModel.fromJson(
            {"id": eventDoc.id, ...eventDoc.data() as Map<String, dynamic>});
      } else {
        // If no event is found with that name, return null
        print("No event found");
        return null;
      }
    } catch (e) {
      print("Error fetching event by name: $e");
      return null;
    }
  }

  Future<List<EventModel>> getEventsByUserId(String userId) async {
    try {
      print("Fetching events for userId: $userId");
      // Query Firestore for events associated with the given userId
      QuerySnapshot snapshot = await _firestore
          .collection('events')
          .where('userId', isEqualTo: userId)
          .get();

      print(snapshot.docs.first.data());

      // Map the query result to a list of EventModel objects
      List<EventModel> events = snapshot.docs
          .map((doc) => EventModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      print(events.first.name);
      return events;
    } catch (e) {
      print("Error fetching events by userId: $e");
      return [];
    }
  }
}
