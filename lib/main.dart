import 'package:flutter/material.dart';
import 'package:hedeyety/providers/ThemeProvider.dart';
import 'package:hedeyety/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

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

  // Initialize your repository and storage services (as you have in your code)
  final repository = Repository();
  final sqfliteService = SqfliteService();
  await sqfliteService.initialize('my_database.db');
  await repository.initialize(sqfliteService);

  runApp(HedieatyApp());
}

class HedieatyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) =>
                ThemeProvider()), // Provide the ThemeProvider here
      ],
      child: Builder(
        builder: (context) {
          // Access the current theme from the ThemeProvider
          final themeProvider = Provider.of<ThemeProvider>(context);

          return MaterialApp(
            theme: themeProvider.currentTheme, // Set the theme dynamically
            initialRoute: AppRoutes.welcome,
            routes: {
              AppRoutes.welcome: (context) => WelcomeScreen(),
              AppRoutes.login: (context) => LoginScreen(),
              AppRoutes.signup: (context) => SignupScreen(),
              AppRoutes.home: (context) => HomeScreen(),
              AppRoutes.homeStack: (context) => HomeStack(),
              AppRoutes.events: (context) => EventsListScreen(),
              AppRoutes.profile: (context) => ProfileScreen(),
            },
          );
        },
      ),
    );
  }
}
