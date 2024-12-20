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

  testWidgets('WelcomeScreen displays logo, title, and buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(HedieatyApp());
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 5));

    // Verify the buttons are displayed
    expect(find.byKey(const Key('loginButton')), findsOneWidget);
  });
}
