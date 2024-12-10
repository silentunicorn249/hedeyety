import 'Gift.dart';

class Event {
  final String title;
  final DateTime date;
  final List<Gift> gifts;

  Event({required this.title, required this.date, required this.gifts});
}
