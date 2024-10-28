import 'package:flutter/material.dart';
import 'package:hedeyety/pages/AuthPage.dart';
import 'package:hedeyety/pages/HomePage.dart';

import 'pages/EventList.dart';
import 'pages/GiftDetails.dart';
import 'pages/GiftList.dart';
import 'pages/MyGift.dart';
import 'pages/ProfilePage.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => AuthPage(),
      '/home': (context) => HomePage(),
      '/events': (context) => EventListPage(),
      '/gifts': (context) => GiftListPage(),
      '/gift-details': (context) => GiftDetailsPage(),
      '/profile': (context) => ProfilePage(),
      '/pledged-gifts': (context) => PledgedGiftsPage(),
    },
  ));
}
