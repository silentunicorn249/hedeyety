import 'package:flutter/material.dart';
import 'package:hedeyety/core/constants/dummy_data.dart';

import '../../../auth/domain/entities/user.dart';

class PledgedGiftsScreen extends StatelessWidget {
  UserEntity person = DummyData.users[0];

  @override
  Widget build(BuildContext context) {
    final pledgedGifts = DummyData.gifts;

    return Scaffold(
      appBar: AppBar(title: Text('My Pledged Gifts')),
      body: ListView.builder(
        itemCount: pledgedGifts.length,
        itemBuilder: (context, index) {
          final gift = pledgedGifts[index];
          return ListTile(
            title: Text(gift.name),
            subtitle: Text('Pledged for: ${gift.name}'),
          );
        },
      ),
    );
  }
}
