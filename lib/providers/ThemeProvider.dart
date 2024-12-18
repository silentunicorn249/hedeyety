import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  ThemeData get currentTheme {
    return _isDark ? ThemeData.dark() : ThemeData.light();
  }

  ThemeProvider() {
    _loadTheme();
  }

  // Load the theme from SharedPreferences
  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? isDark = prefs.getInt("theme");

    if (isDark == null) {
      // Set default theme if no preference is found
      await prefs.setInt("theme", 0);
      _isDark = false; // default to light theme
    } else {
      _isDark = isDark == 1;
    }

    notifyListeners(); // Notify listeners so the UI updates
  }

  // Toggle the theme and save the setting
  Future<void> toggleTheme() async {
    setTheme(_isDark = !_isDark);
  }

  Future<void> setTheme(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("theme", _isDark ? 0 : 1);
    notifyListeners();
  }
}
