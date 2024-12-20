import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hedeyety/core/routes/routes.dart';
import 'package:hedeyety/features/auth/presentation/screens/welcome_screen.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([NavigatorObserver])
void main() {
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: WelcomeScreen(),
      routes: {
        AppRoutes.login: (context) => Scaffold(body: Text('Login Screen')),
        AppRoutes.signup: (context) => Scaffold(body: Text('Signup Screen')),
      },
    );
  }

  testWidgets('WelcomeScreen displays logo, title, and buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Verify the logo is displayed
    expect(find.byType(Image), findsOneWidget);

    // Verify the title is displayed
    expect(find.text('Hedeyety'), findsOneWidget);

    // Verify the buttons are displayed
    expect(find.byKey(const Key('loginButton')), findsOneWidget);
    expect(find.byKey(const Key('signupButton')), findsOneWidget);
  });

  testWidgets('Tapping the Log in button navigates to the Login screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Tap the login button
    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pumpAndSettle();

    // Verify navigation to the Login screen
    expect(find.text('Login Screen'), findsOneWidget);
  });

  testWidgets('Tapping the Sign up button navigates to the Signup screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Tap the signup button
    await tester.tap(find.byKey(const Key('signupButton')));
    await tester.pumpAndSettle();

    // Verify navigation to the Signup screen
    expect(find.text('Signup Screen'), findsOneWidget);
  });
}
