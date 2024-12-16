import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedeyety/features/events/presentation/screens/add_event_screen.dart';
import 'package:hedeyety/features/profile/presentation/screens/add_friend_screen.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/routes.dart';
import '../../../auth/data/datasources/user_repo_local.dart';
import '../../../events/presentation/providers/friends_provider.dart';
import '../../../events/presentation/screens/events_list_screen.dart';

class HomeScreen extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  final _repo = UserRepoLocal();

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
          child: AddFriendScreen(),
        ),
      ),
    );
  }

  void handleLogout(BuildContext context) async {
    await _repo.eraseAll();
    FirebaseAuth.instance.signOut();
    Navigator.popAndPushNamed(context, AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            // add settings
          },
        ),
        title: const Text('Friends List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {
              // Logout logic
              handleLogout(context);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addFriendModal(context),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          MaterialButton(
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

                    return ListTile(
                      leading: const CircleAvatar(),
                      title: Text(person.name),
                      subtitle: Text('Email: ${person.email}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          profileProvider.deleteUser(person.id);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventsListScreen(
                                userId: person.id, name: person.name),
                          ),
                        );
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
