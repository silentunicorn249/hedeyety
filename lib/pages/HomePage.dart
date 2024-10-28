import 'package:flutter/material.dart';
import 'package:hedeyety/components/CreateEventList.dart';

import '../components/FriendRow.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CreateEvent(),
        Friendrow(),
        Friendrow(),
      ],
    );
  }
}
