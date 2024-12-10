import 'package:flutter/material.dart';
import 'package:hedeyety/screens/events_list_screen.dart';
import 'package:hedeyety/screens/gift_detail_screen.dart';
import 'package:hedeyety/screens/gift_list_screen.dart';
import 'package:hedeyety/screens/home_screen.dart';
import 'package:hedeyety/screens/login_screen.dart';
import 'package:hedeyety/screens/my_pledged_gift_screen.dart';
import 'package:hedeyety/screens/welcome_screen.dart';

import 'routes.dart';
import 'screens/home_stack.dart';
import 'screens/profile_screen.dart';
import 'screens/signup_screen.dart';

void main() {
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
        AppRoutes.giftDetails: (context) => GiftDetailsScreen(),
        AppRoutes.gifts: (context) => GiftListScreen(),
        AppRoutes.pledgedGifts: (context) => PledgedGiftsScreen(),
      },
    );
  }
}
