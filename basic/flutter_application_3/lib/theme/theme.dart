// Store all of our theme based information
import 'package:flutter/material.dart';

// Store all of the basic information for light mode
ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
        surface: Colors.grey.shade400,
        primary: Colors.grey.shade300,
        secondary: Colors.grey.shade200));

// Store all of the basic information for dark mode
ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
        surface: Colors.grey.shade900,
        primary: Colors.grey.shade800,
        secondary: Colors.grey.shade700));
