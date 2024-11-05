import 'package:flutter/material.dart';
import 'package:flutter_application_3/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  // Get the theme data for the app
  ThemeData get themeData => _themeData;
  // Set the theme data
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    _themeData = _themeData == lightMode ? darkMode : lightMode;
    // Change the look of the
    notifyListeners();
  }
}
