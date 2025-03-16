import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isSystemDark = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
    _isDarkTheme = prefs.getBool('isDarkTheme') ?? isSystemDark;
    notifyListeners();
  }

  Future<void> toggleTheme(bool value) async {
    _isDarkTheme = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', value);
  }
}