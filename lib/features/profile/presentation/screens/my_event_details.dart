import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedeyety/features/gifts/data/datasources/gift_repo_remote.dart';

import '../../../events/data/models/event_model.dart';
import '../../../gifts/data/models/gift_model.dart';
import '../../../gifts/presentation/screens/add_gift_Screen.dart';

class MyEventDetailsScreen extends StatefulWidget {
  final EventModel event;
  final String currentUserId = FirebaseAuth
      .instance.currentUser!.uid; // Add this parameter to pass current user ID

  MyEventDetailsScreen({super.key, required this.event});

  @override
  State<MyEventDetailsScreen> createState() => _MyEventDetailsScreenState();
}

class _MyEventDetailsScreenState extends State<MyEventDetailsScreen> {
  late Future<List<GiftModel>> _giftsFuture;
  // final GiftRepoLocal _giftRepoLocal = GiftRepoLocal();
  final GiftRepoRemote _giftRepoRemote = GiftRepoRemote();

  @override
  void initState() {
    super.initState();
    _giftsFuture = _giftRepoRemote.getAllGiftsByEvent(widget.event.id);
  }

  void _addGift() async {
    var newGiftData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddGiftScreen(eventId: widget.event.id),
      ),
    );

    if (newGiftData != null) {
      final newGift = GiftModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: newGiftData["name"],
        category: newGiftData["category"],
        description: newGiftData["description"],
        price: newGiftData["price"],
        isPledged: false,
        eventId: newGiftData["eventId"],
      );

      await _giftRepoRemote.saveGift(newGift);

      setState(() {
        _giftsFuture = _giftRepoRemote.getAllGiftsByEvent(widget.event.id);
      });
    }
  }

  void _editGift(GiftModel gift) async {
    var updatedGiftData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddGiftScreen(eventId: widget.event.id),
      ),
    );

    if (updatedGiftData != null) {
      final updatedGift = GiftModel(
        id: gift.id,
        name: updatedGiftData["name"],
        category: updatedGiftData["category"],
        description: updatedGiftData["description"],
        price: updatedGiftData["price"],
        isPledged: gift.isPledged, // Keep pledge status the same
        eventId: updatedGiftData["eventId"],
      );

      await _giftRepoRemote.saveGift(updatedGift);

      setState(() {
        _giftsFuture = _giftRepoRemote.getAllGiftsByEvent(widget.event.id);
      });
    }
  }

  Widget _buildGiftCard(GiftModel gift) {
    bool isCreator = widget.currentUserId == widget.event.userId;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              gift.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text("Category: ${gift.category}"),
            Text("Description: ${gift.description}"),
            Text("Price: \$${gift.price.toStringAsFixed(2)}"),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  gift.isPledged ? "Pledged: ✅" : "Pledged: ❌",
                  style: TextStyle(
                      color: gift.isPledged ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold),
                ),
                if (!gift.isPledged && isCreator)
                  // Show "Edit" button if creator and gift is not pledged
                  ElevatedButton.icon(
                    onPressed: () => _editGift(gift),
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  )
                else if (!isCreator)
                  // Show "Pledge" button if not the creator
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        gift.isPledged = !gift.isPledged;
                        _giftRepoRemote.saveGift(gift); // Save updated status
                      });
                    },
                    icon: Icon(gift.isPledged ? Icons.undo : Icons.done),
                    label: Text(gift.isPledged ? "Unpledge" : "Pledge"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          gift.isPledged ? Colors.red : Colors.green,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.name),
      ),
      body: Column(
        children: [
          // Event details
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blueGrey[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.event.name,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text("Date: ${widget.event.date}"),
                Text("Location: ${widget.event.location}"),
                const SizedBox(height: 8),
                Text(
                  "Description:",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(widget.event.desc),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Gifts list
          Expanded(
            child: FutureBuilder<List<GiftModel>>(
              future: _giftsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "No gifts found for this event.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                } else {
                  final gifts = snapshot.data!;
                  return ListView.builder(
                    itemCount: gifts.length,
                    itemBuilder: (context, index) =>
                        _buildGiftCard(gifts[index]),
                  );
                }
              },
            ),
          ),

          // Add gift button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _addGift,
              icon: const Icon(Icons.add),
              label: const Text("Add Gift"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
