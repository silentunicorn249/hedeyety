import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hedeyety/features/auth/presentation/screens/welcome_screen.dart';
import 'package:hedeyety/features/events/data/datasources/event_repo_local.dart';
import 'package:hedeyety/features/profile/data/datasources/friends_repo_local.dart';
import 'package:hedeyety/providers/ThemeProvider.dart';
import 'package:provider/provider.dart';

import 'core/routes/routes.dart';
import 'features/auth/data/datasources/user_repo_local.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/signup_screen.dart';
import 'features/events/presentation/providers/friends_provider.dart';
import 'features/gifts/data/datasources/gift_repo_local.dart';
import 'features/profile/presentation/screens/home_stack.dart';
import 'features/profile/presentation/screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userRepo = UserRepoLocal();
  await userRepo.initialize("my_db");
  final frRepo = FriendRepoLocal();
  await frRepo.initialize("my_db");
  final evRepo = EventRepoLocal();
  await evRepo.initialize("my_db");
  await GiftRepoLocal().initialize("my_db");
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
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FriendsProvider(),
        ),
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
              AppRoutes.homeStack: (context) => HomeStack(),
              AppRoutes.profile: (context) => ProfileScreen(),
            },
          );
        },
      ),
    );
  }
}
