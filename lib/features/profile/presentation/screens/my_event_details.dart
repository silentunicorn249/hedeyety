import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedeyety/features/events/presentation/screens/add_event_screen.dart';
import 'package:hedeyety/features/gifts/data/datasources/gift_repo_remote.dart';
import 'package:http/http.dart' as http;

import '../../../events/data/datasources/event_repo_local.dart';
import '../../../events/data/datasources/event_repo_remote.dart';
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
      print(newGiftData);

      // Retrieve the image path from the newGiftData
      final imagePath = newGiftData["imagePath"];
      String? uploadedImageUrl;

      if (imagePath != null && imagePath.isNotEmpty) {
        // Upload the image to Imgur and get the URL
        uploadedImageUrl = await _uploadImageToImgur(File(imagePath));
      }

      if (uploadedImageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to upload image. Please try again."),
          ),
        );
        return;
      }

      final newGift = GiftModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: newGiftData["name"],
        category: newGiftData["category"],
        description: newGiftData["description"],
        price: newGiftData["price"],
        pledgedId: "",
        eventId: newGiftData["eventId"],
        imageUrl: uploadedImageUrl,
      );

      // Save the gift remotely
      await _giftRepoRemote.saveGift(newGift);

      // Reload the gifts
      _reloadGifts();
    }
  }

  Future<String?> _uploadImageToImgur(File imageFile) async {
    const String clientId =
        "e97fec3580a41c8"; // Replace with your Imgur Client ID

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("https://api.imgur.com/3/image"),
      );

      // Add the image file to the request
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));

      // Add the authorization header with the client ID
      request.headers['Authorization'] = 'Client-ID $clientId';

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseData);

        // Extract the image URL from the response
        return jsonData['data']['link'];
      } else {
        print("Failed to upload image. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  void _reloadGifts() {
    setState(() {
      _giftsFuture = _giftRepoRemote.getAllGiftsByEvent(widget.event.id);
    });
  }

  void _openEditEventModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: AddEventScreen(),
        ),
      ),
    );
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.event.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color:
                                Colors.blueAccent, // Adding color for the title
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: _openEditEventModal,
                        ),
                      ],
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
                    const SizedBox(height: 16),

                    // Status marker and toggle
                    Row(
                      children: [
                        // Status marker
                        Text(
                          widget.event.isPublic
                              ? "Public Event"
                              : "Private Event",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: widget.event.isPublic
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        const Spacer(),

                        // Checkbox
                        Row(
                          children: [
                            const Text("Public"),
                            Checkbox(
                              value: widget.event.isPublic,
                              onChanged: (bool? newValue) async {
                                if (newValue!) {
                                  await EventRepoLocal().updateEventPrivateFlag(
                                      widget.event.id, newValue);
                                  await EventRepoRemote()
                                      .saveEvent(widget.event);
                                  setState(() {
                                    widget.event.isPublic = newValue;
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'El ragel la yomken yerga3 fi kelmeto'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
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
                  print(
                      "This event key is: ${const ValueKey("GiftCard0").value}");
                  return ListView.builder(
                    itemCount: gifts.length,
                    itemBuilder: (context, index) => GiftCard(
                      key: ValueKey("GiftCard$index"),
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
