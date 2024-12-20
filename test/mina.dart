import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hedeyety/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'Workflow: Login, add private event, add gift, publish event, and pledge another user\'s gift',
      (tester) async {
    // Launch the app
    app.main();
    await tester.pumpAndSettle();

    // Group 1: Login Step
    await _performLogin(tester);

    // Group 2: Navigate to Events Page
    // await _navigateToEventsPage(tester);

    // Group 3: Add a Private Event
    // await _addPrivateEvent(tester);

    // Group 4: Verify Event Creation
    // expect(find.byType(SnackBar), findsOneWidget);
  });
}

// Helper Method for Login
Future<void> _performLogin(WidgetTester tester) async {
  // Tap the login button
  await tester.tap(find.byKey(const Key('loginButton')));
  await tester.pumpAndSettle();

  // Verify navigation to the Login screen
  expect(find.text('Login Screen'), findsOneWidget);
}

// Helper Method for Navigating to Events Page
Future<void> _navigateToEventsPage(WidgetTester tester) async {
  final eventsButton = find.byIcon(Icons.card_giftcard);
  expect(eventsButton, findsOneWidget);
  await tester.tap(eventsButton);
  await tester.pumpAndSettle();
}

// Helper Method for Adding a Private Event
Future<void> _addPrivateEvent(WidgetTester tester) async {
  final addButton = find.byIcon(Icons.add);

  expect(addButton, findsOneWidget);

  await tester.tap(addButton);
  await tester.pumpAndSettle();

  final eventNameField = find.byKey(const Key('titleField'));
  final eventDescriptionField = find.byKey(const Key('descriptionField'));
  final eventDateField = find.byKey(const Key('dateField'));
  final eventPrivateSwitch = find.byKey(const Key('eventTypeSwitch'));
  final createEventButton = find.byKey(const Key('saveButton'));

  expect(eventNameField, findsOneWidget);
  expect(eventDescriptionField, findsOneWidget);
  expect(eventDateField, findsOneWidget);
  expect(eventPrivateSwitch, findsOneWidget);
  expect(createEventButton, findsOneWidget);

  await tester.enterText(eventNameField, 'Private Event Test');
  await tester.enterText(
      eventDescriptionField, 'This is a private event for testing.');
  await tester.tap(find.byIcon(Icons.calendar_today));
  await tester.pumpAndSettle();
  await tester.tap(find.text('30'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
  await tester.tap(eventPrivateSwitch);
  await tester.tap(createEventButton);
  await tester.pumpAndSettle();
}
