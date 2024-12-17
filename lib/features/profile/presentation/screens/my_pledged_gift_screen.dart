import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../gifts/data/datasources/gift_repo_remote.dart';
import '../../../gifts/data/models/gift_model.dart';

class PledgedGiftsScreen extends StatefulWidget {
  const PledgedGiftsScreen({Key? key}) : super(key: key);

  @override
  _PledgedGiftsScreenState createState() => _PledgedGiftsScreenState();
}

class _PledgedGiftsScreenState extends State<PledgedGiftsScreen> {
  final GiftRepoRemote _giftRepoRemote = GiftRepoRemote();

  @override
  void initState() {
    super.initState();
  }

  Widget _buildGiftCard(GiftModel gift) {
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
                  gift.pledgedId.isNotEmpty ? "Pledged: ✅" : "Pledged: ❌",
                  style: TextStyle(
                      color:
                          gift.pledgedId.isNotEmpty ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold),
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
        title: const Text('Pledged Gifts'),
      ),
      body: FutureBuilder<List<GiftModel>>(
        future: _giftRepoRemote.getAllPledgedGifts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No pledged gifts found.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          } else {
            final pledgedGifts = snapshot.data!
                .where((gift) =>
                    gift.pledgedId ==
                    FirebaseAuth
                        .instance.currentUser!.uid) // Filter pledged gifts
                .toList();
            return ListView.builder(
              itemCount: pledgedGifts.length,
              itemBuilder: (context, index) =>
                  _buildGiftCard(pledgedGifts[index]),
            );
          }
        },
      ),
    );
  }
}
