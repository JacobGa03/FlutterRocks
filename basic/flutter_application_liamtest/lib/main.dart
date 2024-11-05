import 'package:flutter/material.dart';
import 'package:flutter_application_liamtest/web_view_container.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Flutter App',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      routes: {
        '/': (context) => const WebViewExample(),
        '/webViewContainer': (context) => WebViewContainer(
              navigatorKey: navigatorKey,
            ),
        '/requestSubmitted': (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/');
                  },
                  child: const Text("Go Back"),
                ),
              ),
            ),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WebView"),
      ),
      body: content(),
    );
  }

  Widget content() {
    return Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/webViewContainer');
            },
            child: const Text("PayU")));
  }
}
