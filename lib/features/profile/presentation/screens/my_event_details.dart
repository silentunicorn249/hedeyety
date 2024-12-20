import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedeyety/features/gifts/data/datasources/gift_repo_remote.dart';

import '../../../events/data/models/event_model.dart';
import '../../../gifts/data/models/gift_model.dart';
import '../../../gifts/presentation/screens/add_gift_Screen.dart';
import '../../../gifts/presentation/widgets/gift_card.dart';

class MyEventDetailsScreen extends StatefulWidget {
  final EventModel event;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  MyEventDetailsScreen({super.key, required this.event});

  @override
  State<MyEventDetailsScreen> createState() => _MyEventDetailsScreenState();
}

class _MyEventDetailsScreenState extends State<MyEventDetailsScreen> {
  late Future<List<GiftModel>> _giftsFuture;
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
        pledgedId: "",
        eventId: newGiftData["eventId"],
      );

      await _giftRepoRemote.saveGift(newGift);
      _reloadGifts();
    }
  }

  void _reloadGifts() {
    setState(() {
      _giftsFuture = _giftRepoRemote.getAllGiftsByEvent(widget.event.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isCreator = widget.currentUserId == widget.event.userId;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.name),
      ),
      body: Column(
        children: [
          // Event details
          Container(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event Name with Bold Style and Large Font
                    Text(
                      widget.event.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent, // Adding color for the title
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Date and Location with Icons for better visibility
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.grey.shade600,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Date: ${widget.event.date}",
                          style: TextStyle(
                              fontSize: 16, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.grey.shade600,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Location: ${widget.event.location}",
                          style: TextStyle(
                              fontSize: 16, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Description with improved styling
                    const Text(
                      "Description:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.event.desc,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
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
                  print("This event key is: ${ValueKey("GiftCard0").value}");
                  return ListView.builder(
                    itemCount: gifts.length,
                    itemBuilder: (context, index) => GiftCard(
                      key: Key("GiftCard$index"),
                      gift: gifts[index],
                      isCreator: isCreator,
                      giftRepoRemote: _giftRepoRemote,
                      onGiftUpdated: _reloadGifts,
                    ),
                  );
                }
              },
            ),
          ),

          if (isCreator)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: _addGift,
                icon: const Icon(Icons.add),
                label: const Text("Add Gift"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(120,
                      50), // This will increase the width to fill the available space
                ),
              ),
            ),
        ],
      ),
    );
  }
}
