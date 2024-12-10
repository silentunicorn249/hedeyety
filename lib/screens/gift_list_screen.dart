import 'package:flutter/material.dart';

import '../models/Event.dart';
import '../models/Gift.dart';
import 'gift_detail_screen.dart';

class GiftListScreen extends StatefulWidget {
  late Event event;

  @override
  _GiftListScreenState createState() => _GiftListScreenState();
}

class _GiftListScreenState extends State<GiftListScreen> {
  List<Gift> gifts = [];

  @override
  void initState() {
    super.initState();
    gifts = widget.event.gifts;
  }

  void _addNewGift(String name, String description) {
    setState(() {
      gifts.add(Gift(name: name, description: description, category: 'Misc'));
    });
    Navigator.pop(context);
  }

  void _showAddGiftModal() {
    String giftName = '';
    String giftDescription = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow full-screen modal scroll
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
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
                  onChanged: (value) => giftName = value,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Description'),
                  onChanged: (value) => giftDescription = value,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _addNewGift(giftName, giftDescription),
                  child: Text('Add Gift'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.event.title} Gifts')),
      body: ListView.builder(
        itemCount: gifts.length,
        itemBuilder: (context, index) {
          final gift = gifts[index];
          return ListTile(
            title: Text(gift.name),
            subtitle: Text(gift.description),
            trailing: Icon(
              gift.isPledged
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: gift.isPledged ? Colors.green : Colors.red,
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GiftDetailsScreen(),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddGiftModal,
        child: Icon(Icons.add),
      ),
    );
  }
}
