import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedeyety/features/events/presentation/screens/add_event_screen.dart';
import 'package:hedeyety/features/profile/presentation/screens/add_friend_screen.dart';
import 'package:hedeyety/providers/ThemeProvider.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/routes.dart';
import '../../../auth/data/datasources/user_repo_local.dart';
import '../../../events/presentation/providers/friends_provider.dart';
import '../widgets/friend_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _repo = UserRepoLocal();

  late Stream<DocumentSnapshot<Map<String, dynamic>>> _notificationsStream;

  @override
  void initState() {
    super.initState();

    // Initialize the stream to listen for notifications
    _notificationsStream =
        _firestore.collection('notifications').doc(userId).snapshots();

    // Start listening for notifications
    _listenToNotifications();
  }

  void _listenToNotifications() {
    _notificationsStream.listen((snapshot) async {
      if (snapshot.exists) {
        final data = snapshot.data();
        final List<dynamic> notifications = data?['notifications'] ?? [];

        if (notifications.isNotEmpty) {
          // Display the first notification
          final notification = notifications.first;

          _showNotificationSnackbar(
              notification['title'], notification['body']);

          // Remove the notification after displaying
          await _firestore.collection('notifications').doc(userId).update({
            'notifications': FieldValue.arrayRemove([notification]),
          });
        }
      }
    });
  }

  void _showNotificationSnackbar(String title, String body) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title: $body'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void addEventModal(BuildContext context) {
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

  void addFriendModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: AddFriendScreen(
            key: Key("AddFriendScreen"),
          ),
        ),
      ),
    );
  }

  void handleLogout(BuildContext context) async {
    await _repo.eraseAll();
    final friendsProvider =
        Provider.of<FriendsProvider>(context, listen: false);
    await Provider.of<ThemeProvider>(context, listen: false).setTheme(false);
    await friendsProvider.eraseAll();
    await FirebaseAuth.instance.signOut();
    Navigator.popAndPushNamed(context, AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          key: const Key("profileButt"),
          icon: const Icon(Icons.person),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.profile);
          },
        ),
        title: const Text('Friends List'),
        actions: [
          IconButton(
            key: const Key("logoutButt"),
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {
              // Logout logic
              handleLogout(context);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key("addFriendButt"),
        onPressed: () => addFriendModal(context),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          MaterialButton(
            key: Key("addEventButt"),
            onPressed: () => addEventModal(context),
            child: const Text("Add Event"),
          ),
          Expanded(
            child: Consumer<FriendsProvider>(
              builder: (context, profileProvider, child) {
                if (profileProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (profileProvider.profiles.isEmpty) {
                  return const Center(child: Text('No Friends available yet.'));
                }

                return ListView.builder(
                  itemCount: profileProvider.profiles.length,
                  itemBuilder: (context, index) {
                    final person = profileProvider.profiles[index];
                    debugPrint("Dodged a bullet ${person.email}");

                    return FriendTile(
                      key: Key("friendTile$index"),
                      person: person,
                      onDelete: () {
                        profileProvider.deleteUser(person.id);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
