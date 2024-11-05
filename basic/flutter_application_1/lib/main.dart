import 'package:flutter/material.dart';

// Our psvm, where the app starts
void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _counter = 0;

  void incrementCounter() {
    // Rebuild the widget
    setState(() {
      // Increment the counter by one
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFFCAF0F8),
        appBar: AppBar(
          title: Center(child: Text("My first app")),
          backgroundColor: Color(0xFF0077B6),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.logout))],
        ),
        body: Column(children: [
          Container(
            child: ElevatedButton(
                onPressed: incrementCounter, child: Text("Click me!")),
          ),
          Text(_counter.toString())
        ]),
      ),
    );
  }
}
