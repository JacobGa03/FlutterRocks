import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_2/pages/todopage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // Allow us to store some information
  await Hive.initFlutter();

  var box = await Hive.openBox('mybox');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Simple ToDo",
      home: const ToDoPage(),
      theme: ThemeData(
          useMaterial3: true,
          primaryColor: Color(0xFFFFD700),
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFFFFD700), // Yellow-ish primary color
            secondary: Colors
                .grey, // You can choose a secondary color that complements the yellow-ish scheme
            surface: Colors
                .white, // Surface color can be white or a light neutral color
            error: Colors.red, // Error color can be a bold red
            onPrimary: Colors.black, // Text color on primary background
            onSecondary: Colors.white, // Text color on secondary background
            onSurface: Colors.black, // Text color on surface background
            onError: Colors.white, // Text color on error background
          )),
      debugShowCheckedModeBanner: false,
    );
  }
}
