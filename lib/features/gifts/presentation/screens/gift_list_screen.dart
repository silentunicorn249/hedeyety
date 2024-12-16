import 'package:flutter/material.dart';
import 'package:hedeyety/core/constants/dummy_data.dart';
import 'package:hedeyety/features/gifts/presentation/screens/add_gift_Screen.dart';

import '../../../events/domain/entities/event.dart';
import '../../domain/entities/gift.dart';
import 'gift_detail_screen.dart';

class GiftListScreen extends StatefulWidget {
  EventEntity event = EventEntity(
      id: "id",
      desc: "desc",
      name: "name",
      location: "location",
      userId: "userId",
      date: DateTime(2017, 9, 7, 17, 30).toString(),
      isPublic: true);

  @override
  _GiftListScreenState createState() => _GiftListScreenState();
}

class _GiftListScreenState extends State<GiftListScreen> {
  List<Gift> gifts = DummyData.gifts;

  @override
  void initState() {
    super.initState();
    // gifts = widget.event.gifts;
    print(gifts);
  }

  void _showAddGiftModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => SingleChildScrollView(
          child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddGiftScreen(),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.event.name} Gifts')),
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
