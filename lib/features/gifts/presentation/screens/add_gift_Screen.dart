import 'package:flutter/material.dart';

class AddGiftScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Gift Name'),
              // onChanged: (value) => giftName = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Description'),
              // onChanged: (value) => giftDescription = value,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // setState(() {
                //   gifts.add(Gift(name: name, description: description, category: 'Misc'));
                // });
                Navigator.pop(context);
              },
              child: Text('Add Gift'),
            ),
          ],
        ),
      ),
    );
  }
}
