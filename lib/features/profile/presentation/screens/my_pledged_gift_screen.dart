import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../gifts/data/datasources/gift_repo_remote.dart';
import '../../../gifts/data/models/gift_model.dart';
import '../../../gifts/presentation/widgets/gift_card.dart';

class PledgedGiftsScreen extends StatefulWidget {
  const PledgedGiftsScreen({Key? key}) : super(key: key);

  @override
  _PledgedGiftsScreenState createState() => _PledgedGiftsScreenState();
}

class _PledgedGiftsScreenState extends State<PledgedGiftsScreen> {
  final GiftRepoRemote _giftRepoRemote = GiftRepoRemote();

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                    gift.pledgedId == currentUserId) // Filter pledged gifts
                .toList();

            return ListView.builder(
              itemCount: pledgedGifts.length,
              itemBuilder: (context, index) {
                final gift = pledgedGifts[index];
                return GiftCard(
                  key: ValueKey("GiftCard$index"),
                  gift: gift,
                  isCreator: false,
                  giftRepoRemote: _giftRepoRemote,
                  onGiftUpdated: () {
                    setState(
                        () {}); // Refresh the list when pledge status changes
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
