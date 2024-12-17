import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedeyety/features/auth/data/datasources/user_repo_remote.dart';
import 'package:hedeyety/features/auth/data/models/user_model.dart';
import 'package:hedeyety/features/profile/presentation/screens/my_pledged_gift_screen.dart';
import 'package:hedeyety/providers/ThemeProvider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Load the saved theme from SharedPreferences and set it in the ThemeProvider
  Future<UserModel?> _loadProfile() async {
    final repo = UserRepoRemote();
    return await repo.getUser(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: _loadProfile(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Text('Loading....');
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final userData = snapshot.data as UserModel;
                return Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('images/logo.jpg'),
                    ),
                    ListTile(
                      title: Text('${userData.name} ${userData.email}'),
                      subtitle: const Text('Edit Profile Info'),
                      onTap: () {
                        // Edit profile logic
                      },
                    ),
                    ListTile(
                      title: const Text('My Pledged Gifts'),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PledgedGiftsScreen())),
                    ),
                    Switch(
                      value: Provider.of<ThemeProvider>(context)
                          .isDark, // Use the value from ThemeProvider
                      onChanged: (value) async {
                        // Toggle theme in ThemeProvider
                        await Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme();
                      },
                    ),
                  ],
                );
              }
          }
        },
      ),
    );
  }
}
