import 'package:flutter/material.dart';
import 'package:hedeyety/screens/welcome_screen.dart';

import 'routes.dart';
import 'screens/events_list_screen.dart';
import 'screens/home_screen.dart';
import 'screens/home_stack.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/signup_screen.dart';
import 'services/local_storage.dart';
import 'services/repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Choose either Firebase or Sqflite for storage
  final repository = Repository();

  // For Firebase
  // await repository.initialize(FirebaseService());

  // For Sqflite
  final sqfliteService = SqfliteService();
  await sqfliteService.initialize('my_database.db');
  await repository.initialize(sqfliteService);
  runApp(HedieatyApp());
}

class HedieatyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoutes.welcome,
      routes: {
        AppRoutes.welcome: (context) => WelcomeScreen(),
        AppRoutes.login: (context) => LoginScreen(),
        AppRoutes.signup: (context) => SignupScreen(),
        AppRoutes.home: (context) => HomeScreen(),
        AppRoutes.homeStack: (context) => HomeStack(),
        AppRoutes.events: (context) => EventsListScreen(),
        AppRoutes.profile: (context) => ProfileScreen(),
        // AppRoutes.giftDetails: (context) => GiftDetailsScreen(),
        // AppRoutes.gifts: (context) => GiftListScreen(),
        // AppRoutes.pledgedGifts: (context) => PledgedGiftsScreen(),
      },
    );
  }
}
