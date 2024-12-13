import '../features/auth/domain/entities/user.dart';
import '../features/events/domain/entities/event.dart';

class ProfileService {
  // Dummy profile data
  UserEntity _dummyProfile = UserEntity(
    id: '1',
    name: 'Mark Johnson',
    email: 'mark@example.com',
    events: [],
  );

  // Get the profile data
  UserEntity getProfile() {
    return _dummyProfile;
  }

  // Add an event to the user's profile
  void addEventToProfile(Event event) {
    _dummyProfile.events.add(event);
  }
}
