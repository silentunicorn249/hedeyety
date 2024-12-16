import 'package:flutter/material.dart';

class PledgedGiftsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pledgedGifts = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pledged Gifts'),
        automaticallyImplyLeading: false,
      ),
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
