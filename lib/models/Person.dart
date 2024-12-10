import 'Event.dart';

class Person {
  final String name;
  final String profileImage;
  final List<Event> events;

  Person(
      {required this.name, required this.profileImage, required this.events});
}
