import 'package:flutter/material.dart';
import 'package:hedeyety/features/profile/presentation/screens/my_events_screen.dart';

import 'home_screen.dart';
import 'profile_screen.dart';

class HomeStack extends StatefulWidget {
  @override
  _HomeStackState createState() => _HomeStackState();
}

class _HomeStackState extends State<HomeStack> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    MyEventsScreen(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
