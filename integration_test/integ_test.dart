import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hedeyety/features/auth/data/datasources/user_repo_local.dart';
import 'package:hedeyety/features/events/data/datasources/event_repo_local.dart';
import 'package:hedeyety/features/gifts/data/datasources/gift_repo_local.dart';
import 'package:hedeyety/features/profile/data/datasources/friends_repo_local.dart';
import 'package:hedeyety/main.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final userRepo = UserRepoLocal();
    await userRepo.initialize("my_db");
    final frRepo = FriendRepoLocal();
    await frRepo.initialize("my_db");
    final evRepo = EventRepoLocal();
    await evRepo.initialize("my_db");
    await GiftRepoLocal().initialize("my_db");
    await Firebase.initializeApp();
  });
  Future<void> _startApp(WidgetTester tester) async {
    await tester.pumpWidget(HedieatyApp());
    await tester.pumpAndSettle();
  }

  Future<void> _goToLoginPage(tester) async {
    await tester.pumpWidget(HedieatyApp());
    await tester.pumpAndSettle(); // Ensure initial load

    // Ensure SignInPage is loaded
    expect(find.byKey(const Key('loginButton')), findsOneWidget);
    expect(find.byKey(const Key('signupButton')), findsOneWidget);

    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pumpAndSettle();
  }

  Future<void> _goodLogin(tester) async {
    await _goToLoginPage(tester);
    // Enter valid email and correct password
    await tester.enterText(find.byKey(const Key('emailField')), 's@s.com');
    await tester.pumpAndSettle(); // Ensure text is entered

    // Clear the password field
    await tester.enterText(find.byKey(const Key('passwordField')), '');
    await tester.pumpAndSettle(); // Ensure field is cleared

    await tester.enterText(find.byKey(const Key('passwordField')), '123456');
    await tester.pumpAndSettle(); // Ensure text is entered

    // Hide the keyboard after entering password
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Tap the sign-in button
    await tester.ensureVisible(find.byKey(const Key('loginButton')));
    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pumpAndSettle();

    await Future.delayed(const Duration(seconds: 2));

    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 1));
    // Verify that the SignInPage is no longer visible, indicating successful navigation
    expect(find.byKey(const Key('loginButton')), findsNothing);

    // Ensure that MainPage is visible after the navigation
    expect(find.byKey(const Key('HomeScreen')), findsOneWidget);
  }

  testWidgets('Wrong credentials', (WidgetTester tester) async {
    await _goToLoginPage(tester);
    // Enter valid email and wrong password
    await tester.enterText(find.byKey(const Key('emailField')), 's@s.com');
    await tester.pumpAndSettle(); // Ensure text is entered

    await tester.enterText(
        find.byKey(const Key('passwordField')), 'wrongpassword');
    await tester.pumpAndSettle(); // Ensure text is entered

    // Hide the keyboard after entering password
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Tap the sign-in button
    await tester.ensureVisible(find.byKey(const Key('loginButton')));
    await tester.tap(find.byKey(const Key('loginButton')));
    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    await Future.delayed(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Verify that the SignInPage is still visible (incorrect password scenario)
    expect(find.byKey(const Key('loginButton')), findsOneWidget);
  });

  testWidgets("sign in with good credentials", (WidgetTester tester) async {
    await _goodLogin(tester);
  });

  testWidgets("Create Event", (WidgetTester tester) async {
    await _startApp(tester);

    // Perform Add Event
    await tester.tap(find.byKey(const Key("addEventButt")));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byKey(const Key('eventNameField')), 'New Test Event');
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byKey(const Key('eventLocationField')), 'Test Event Location');
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byKey(const Key('eventDescField')), 'Test Event Desc');
    await tester.pumpAndSettle();

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Trigger the Date Picker
    await tester.tap(find.byKey(const Key('eventDateField')));
    await tester.pumpAndSettle();

    // Go to next month
    await tester.tap(find.byTooltip('Next month'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('24'));
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 1));

    await tester.tap(find.byKey(const Key("saveEventButt")));
    await tester.pumpAndSettle();

    await Future.delayed(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 1));

    //Go to events
    await tester.tap(find.byIcon(Icons.event));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 1));
  });

  testWidgets("Show profile", (WidgetTester tester) async {
    await _startApp(tester); // Reset app state

    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 1));

    await tester.tap(find.byKey(const Key("goBackButt")));
    await tester.pumpAndSettle();
  });

  testWidgets("Pledge Friend", (WidgetTester tester) async {
    await _startApp(tester); // Reset app state
    // Ensure HomeScreen is present
    expect(find.byKey(const Key('HomeScreen')), findsOneWidget);

    // Perform Add Friend actions
    await tester.tap(find.byKey(const Key("addFriendButt")));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('phoneNoTextField')), '012');
    await tester.pumpAndSettle();

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('addFriendButton')), findsOneWidget);

    await tester.tap(find.byKey(const Key("addFriendButton")));
    await tester.pumpAndSettle();

    print("Pressed and waiting to add");
    await Future.delayed(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 1));

    print("Starting pledging");

    //Go to pledged gifts and see the current added gift
    await tester.tap(find.byIcon(Icons.card_giftcard_sharp));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));

    //Go back to homeScreen
    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));

    expect(find.byKey(const Key('friendTile0')), findsOneWidget);
    await tester.tap(find.byKey(const Key("friendTile0")));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));

    expect(find.byKey(const Key('EventsListScreen')), findsOneWidget);

    await tester.tap(find.byKey(const Key("EventListTile0")));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));

    expect(find.byKey(const Key('MyEventDetailsScreen')), findsOneWidget);

    await tester.tap(find.byKey(const Key("GiftCard0")));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));

    await tester.tap(find.byKey(const Key("giftBackButt")));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key("GiftCard0Butt")));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 1));

    // Go to Events
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Go to friends
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    //Go to pledged gifts and see the newely added gift
    await tester.tap(find.byIcon(Icons.card_giftcard_sharp));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));
  });
}
