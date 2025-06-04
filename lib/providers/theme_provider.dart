import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  ThemeNotifier() {
    _loadFromPrefs();
  }

  toggleTheme() {
    _isDark = !_isDark;
    _saveToPrefs();
    notifyListeners();
  }

  _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('darkMode') ?? false;
    notifyListeners();
  }

  _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', _isDark);
  }
}
