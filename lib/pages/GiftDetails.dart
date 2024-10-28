import 'package:flutter/material.dart';

class GiftDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gift Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Gift Name'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Description'),
            ),
            DropdownButton<String>(
              items: [
                DropdownMenuItem(
                    child: Text('Electronics'), value: 'Electronics'),
                DropdownMenuItem(child: Text('Books'), value: 'Books'),
              ],
              onChanged: (value) {},
              hint: Text('Select Category'),
            ),
            SwitchListTile(
              title: Text('Pledged'),
              value: false,
              onChanged: (value) {},
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
