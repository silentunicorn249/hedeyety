// Extracted GiftCard Widget
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedeyety/features/events/data/datasources/event_repo_remote.dart';

import '../../data/datasources/gift_repo_remote.dart';
import '../../data/models/gift_model.dart';
import '../screens/gift_detail_screen.dart';

class GiftCard extends StatelessWidget {
  final GiftModel gift;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final bool isCreator;
  final GiftRepoRemote giftRepoRemote;
  final VoidCallback onGiftUpdated;

  GiftCard({
    required super.key,
    required this.gift,
    required this.isCreator,
    required this.giftRepoRemote,
    required this.onGiftUpdated,
  });

  @override
  Widget build(BuildContext context) {
    bool isPledged = gift.pledgedId.isNotEmpty;
    bool isPledgedByCurrentUser = gift.pledgedId == currentUserId;

    print("This GiftCard key is: ${(key as ValueKey).value}Butt");
    return GestureDetector(
      onTap: () {
        // Navigate to Gift Details Screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GiftDetailsScreen(gift: gift),
          ),
        );
      },
      child: Card(
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
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    isPledged ? "Pledged: ✅" : "Pledged: ❌",
                    style: TextStyle(
                        color: isPledged ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                  if (!isCreator)
                    ElevatedButton.icon(
                      key: Key("${(key as ValueKey).value}Butt"),
                      onPressed: () async {
                        String eventUserId =
                            (await EventRepoRemote().getEvent(gift.eventId))!
                                .userId;
                        if (!isPledged) {
                          await giftRepoRemote.updateGiftPledgedStatus(
                            gift.id,
                            currentUserId,
                            eventUserId,
                            "Pledge",
                            "Mabrouk!!! ${gift.name} hatgeelak",
                          );
                        } else if (isPledgedByCurrentUser) {
                          await giftRepoRemote.updateGiftPledgedStatus(
                            gift.id,
                            "",
                            eventUserId,
                            "Unpledge",
                            "7ad rega3 fi kalamo, ${gift.name} too much y3ny",
                          );
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("This gift is already pledged."),
                              ),
                            );
                          }
                          return;
                        }

                        // Safely trigger UI updates
                        if (context.mounted) {
                          onGiftUpdated();
                        }
                      },
                      icon: Icon(
                        isPledgedByCurrentUser
                            ? Icons.undo
                            : isPledged
                                ? Icons.ac_unit_outlined
                                : Icons.check_circle,
                      ),
                      label: Text(
                        isPledgedByCurrentUser
                            ? "Unpledge"
                            : isPledged
                                ? "Already Pledged"
                                : "Pledge",
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPledgedByCurrentUser
                            ? Colors.red
                            : isPledged
                                ? Colors.grey[600]
                                : Colors.green,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
