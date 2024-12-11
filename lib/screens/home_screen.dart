import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedeyety/routes.dart';
import 'package:hedeyety/screens/add_event_screen.dart';
import 'package:hedeyety/screens/add_friend_screen.dart';

import '../models/dummy_data.dart';
import '../models/user.dart';
import 'events_list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserModel> persons = DummyData.users;

  void addEventModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => SingleChildScrollView(
          child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddEventScreen(),
      )),
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
      )),
    );
  }

  void handleLogout() {
    FirebaseAuth.instance.signOut();
    Navigator.popAndPushNamed(context, AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), onPressed: addFriendModal),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: MaterialButton(
          onPressed: handleLogout,
          child: Icon(Icons.arrow_back_sharp),
        ),
        title: Text('Friends List'),
      ),
      body: Column(
        children: [
          MaterialButton(
            onPressed: addEventModal,
            child: Text("Add Friend"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: persons.length,
              itemBuilder: (context, index) {
                final person = persons[index];
                return ListTile(
                  leading: CircleAvatar(
                      // backgroundImage: NetworkImage(person.profileImage),
                      ),
                  title: Text(person.name),
                  subtitle: Text('Events: ${person.email}'),
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
            ),
          ),
        ],
      ),
    );
  }
}
