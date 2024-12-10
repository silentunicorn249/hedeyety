import '../models/Person.dart';
import '../models/event.dart';

class ProfileService {
  // Dummy profile data
  Person _dummyProfile = Person(
    id: '1',
    name: 'Mark Johnson',
    email: 'mark@example.com',
    events: [],
  );

  // Get the profile data
  Person getProfile() {
    return _dummyProfile;
  }

  // Add an event to the user's profile
  void addEventToProfile(Event event) {
    _dummyProfile.events.add(event);
  }
}
