import '../models/event.dart';
import '../models/user.dart';

class ProfileService {
  // Dummy profile data
  User _dummyProfile = User(
    id: '1',
    name: 'Mark Johnson',
    email: 'mark@example.com',
    events: [],
  );

  // Get the profile data
  User getProfile() {
    return _dummyProfile;
  }

  // Add an event to the user's profile
  void addEventToProfile(Event event) {
    _dummyProfile.events.add(event);
  }
}
