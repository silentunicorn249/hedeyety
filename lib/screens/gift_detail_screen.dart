import 'package:flutter/material.dart';
import 'package:hedeyety/models/dummy_data.dart';

import '../models/Gift.dart';

class GiftDetailsScreen extends StatefulWidget {
  Gift gift = dummyPersons[0].events[0].gifts[1];

  @override
  _GiftDetailsScreenState createState() => _GiftDetailsScreenState();
}

class _GiftDetailsScreenState extends State<GiftDetailsScreen> {
  bool isPledged = false;

  @override
  void initState() {
    super.initState();
    isPledged = widget.gift.isPledged;
    print(widget.gift);
  }

  void _togglePledgeStatus() {
    print(widget.gift.price);
    setState(() {
      isPledged = !isPledged;
      widget.gift.isPledged = isPledged;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.gift.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description: ${widget.gift.description}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Category: ${widget.gift.category}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Price: ${widget.gift.price}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            SwitchListTile(
              title: Text('Pledged'),
              value: isPledged,
              onChanged: (value) => _togglePledgeStatus(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Back to Gifts'),
            ),
          ],
        ),
      ),
    );
  }
}
