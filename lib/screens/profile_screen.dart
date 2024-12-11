import 'package:flutter/material.dart';
import 'package:hedeyety/providers/ThemeProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late SharedPreferences pref;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  // Load the saved theme from SharedPreferences and set it in the ThemeProvider
  Future<void> _loadTheme() async {
    pref = await SharedPreferences.getInstance();
    bool isDark = pref.getInt("theme") == 1;

    // Set the initial theme in the ThemeProvider
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Profile')),
      body: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('images/logo.jpg'),
          ),
          ListTile(
            title: Text('Mark Johnson'),
            subtitle: Text('Edit Profile Info'),
            onTap: () {
              // Edit profile logic
            },
          ),
          ListTile(
            title: Text('My Pledged Gifts'),
            onTap: () => Navigator.pushNamed(context, '/pledged-gifts'),
          ),
          Switch(
            value: Provider.of<ThemeProvider>(context)
                .isDark, // Use the value from ThemeProvider
            onChanged: (value) async {
              // Toggle theme in ThemeProvider
              await Provider.of<ThemeProvider>(context, listen: false)
                  .toggleTheme();

              // Save the new theme preference in SharedPreferences
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setInt("theme", value ? 1 : 0);
            },
          ),
        ],
      ),
    );
  }
}
