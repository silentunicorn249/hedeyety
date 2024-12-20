import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Event name validation returns error for empty input', () {
    final eventName = '';
    final result = validateEventName(eventName);
    expect(result, 'Event name cannot be empty');
  });
}
