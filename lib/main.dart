import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hedeyety/features/auth/data/datasources/user_repo_local.dart';
import 'package:hedeyety/features/auth/presentation/screens/welcome_screen.dart';
import 'package:hedeyety/providers/ThemeProvider.dart';
import 'package:provider/provider.dart';

import 'core/routes/routes.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/signup_screen.dart';
import 'features/events/presentation/screens/events_list_screen.dart';
import 'features/profile/presentation/screens/home_screen.dart';
import 'features/profile/presentation/screens/home_stack.dart';
import 'features/profile/presentation/screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userRepo = UserRepoLocal();
  await userRepo.initialize("my_db");
  await Firebase.initializeApp();

  runApp(HedieatyApp());
}

class HedieatyApp extends StatefulWidget {
  @override
  _HedieatyAppState createState() => _HedieatyAppState();
}

class _HedieatyAppState extends State<HedieatyApp> {
  String initialRoute = AppRoutes.welcome; // Default to welcome screen

  @override
  void initState() {
    super.initState();
    _checkUserLoginStatus();
  }

  // Function to check if the user is logged in
  Future<void> _checkUserLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    // print(user);
    setState(() {
      if (user != null) {
        initialRoute = AppRoutes.homeStack;
      }
    });
  }

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
            initialRoute: initialRoute,
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
