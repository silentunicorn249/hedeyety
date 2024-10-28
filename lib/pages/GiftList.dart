import 'package:flutter/material.dart';

class GiftListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gift List')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Smartphone'),
            subtitle: Text('Category: Electronics'),
            trailing:
                Icon(Icons.check_circle, color: Colors.green), // Pledged gift
            onTap: () => Navigator.pushNamed(context, '/gift-details'),
          ),
          ListTile(
            title: Text('Book: Flutter Development'),
            subtitle: Text('Category: Books'),
            trailing: Icon(Icons.radio_button_unchecked,
                color: Colors.red), // Not pledged
            onTap: () => Navigator.pushNamed(context, '/gift-details'),
          ),
        ],
      ),
    );
  }
}
