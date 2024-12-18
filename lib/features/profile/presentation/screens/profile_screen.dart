import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedeyety/features/auth/data/datasources/user_repo_remote.dart';
import 'package:hedeyety/features/auth/data/models/user_model.dart';
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

  // Load user data
  Future<UserModel?> _loadProfile() async {
    final repo = UserRepoRemote();
    return await repo.getUser(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<UserModel?>(
        future: _loadProfile(),
        builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('No data available'));
              } else {
                final userData = snapshot.data!;

                return Column(
                  children: [
                    Stack(
                      children: [
                        // Curved Header Background
                        ClipPath(
                          clipper: CurvedClipper(),
                          child: Container(
                            height: 300,
                            width: double.infinity,
                            color: Colors.deepPurple,
                          ),
                        ),
                        // Profile Picture
                        Positioned(
                          bottom: 0,
                          left: MediaQuery.of(context).size.width / 2 - 60,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 56,
                              backgroundImage: NetworkImage(
                                  'https://robohash.org/${userData.id}'), // User image URL
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 70),
                    // User Name
                    Text(
                      userData.name ?? 'No Name',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 7),
                    // User Email
                    Text(
                      userData.phoneNo ?? 'No Email',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 7),
                    // User Email
                    Text(
                      userData.email ?? 'No Email',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 23),
                    // Theme Toggle
                    SwitchListTile(
                      title: const Text('Dark Theme'),
                      value: Provider.of<ThemeProvider>(context).isDark,
                      onChanged: (value) async {
                        await Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme();
                      },
                    ),
                    // Edit Profile Button
                    ElevatedButton(
                      onPressed: () {
                        // Edit profile logic here
                      },
                      child: const Text('Edit Profile'),
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

// Custom Clipper for Curved Header
class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
