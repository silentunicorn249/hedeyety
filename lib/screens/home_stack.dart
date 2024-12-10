import 'package:flutter/material.dart';
import 'package:hedeyety/routes.dart';
import 'package:hedeyety/screens/my_pledged_gift_screen.dart';
import 'package:hedeyety/screens/welcome_screen.dart';

import 'home_screen.dart';
import 'profile_screen.dart';

class HomeStack extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeStack> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  int _currentIndex = 0;

  // Define the routes corresponding to each BottomNavigationBarItem
  final List<String> _routes = [
    AppRoutes.home,
    AppRoutes.profile,
    AppRoutes.pledgedGifts,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _navigatorKey.currentState!.pushNamedAndRemoveUntil(
      _routes[index],
      (route) => false, // Clears navigation stack to prevent stacking screens
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: _navigatorKey,
        initialRoute: _routes[0],
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          print(settings.name);
          switch (settings.name) {
            case AppRoutes.welcome:
              builder = (BuildContext _) => WelcomeScreen();
              break;
            case AppRoutes.home:
              builder = (BuildContext _) => HomeScreen();
              break;
            case AppRoutes.profile:
              builder = (BuildContext _) => ProfileScreen();
              break;
            case AppRoutes.pledgedGifts:
              builder = (BuildContext _) => PledgedGiftsScreen();
              break;
            default:
              print("path ${settings.name}");
              // builder = (BuildContext _) => Placeholder();
              throw Exception('Invalid route: ${settings.name}');
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_activity),
            label: 'Pledged',
          ),
        ],
      ),
    );
  }
}
