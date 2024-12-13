import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedeyety/core/routes/routes.dart';
import 'package:hedeyety/features/auth/data/datasources/user_repo_local.dart';
import 'package:hedeyety/features/auth/domain/entities/user.dart'; // Ensure this import exists
import 'package:hedeyety/features/events/presentation/screens/add_event_screen.dart';
import 'package:hedeyety/features/events/presentation/screens/events_list_screen.dart';
import 'package:hedeyety/features/profile/presentation/screens/add_friend_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<UserEntity>>
      _profilesFuture; // Declare a future for profiles

  Future<List<UserEntity>> getProfiles() async {
    final repo = UserRepoLocal();
    final res = await repo.getALlUsers();
    return res;
  }

  @override
  void initState() {
    super.initState();
    _profilesFuture = getProfiles(); // Initialize the future to load profiles
  }

  void addEventModal() {
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

  void addFriendModal() {
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

  void handleLogout() {
    FirebaseAuth.instance.signOut();
    Navigator.popAndPushNamed(context, AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
            },
          ),
        ],
        leading: MaterialButton(
          onPressed: handleLogout,
          child: const Icon(Icons.logout_outlined),
        ),
        title: const Text('Friends List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addFriendModal,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          MaterialButton(
            onPressed: addEventModal,
            child: const Text("Add Event"),
          ),
          Expanded(
            child: FutureBuilder<List<UserEntity>>(
              future: _profilesFuture, // Future for profiles
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator()); // Show loading indicator
                }

                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(
                      child: Text(
                          'Error: ${snapshot.error}')); // Show error if any
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text('No profiles available')); // Show if no data
                }

                // Data has been fetched successfully
                List<UserEntity> persons = snapshot.data!;

                return ListView.builder(
                  itemCount: persons.length,
                  itemBuilder: (context, index) {
                    final person = persons[index];
                    return ListTile(
                      leading: CircleAvatar(
                          // backgroundImage: NetworkImage(person.profileImage), // Use the profile image URL
                          ),
                      title: Text(person.name),
                      subtitle: Text('Email: ${person.email}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventsListScreen(),
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
