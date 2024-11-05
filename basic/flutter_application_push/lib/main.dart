import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_push/api/firebase_api.dart';
import 'package:flutter_application_push/firebase_options.dart';
import 'package:flutter_application_push/pages/home_page.dart';
import 'package:flutter_application_push/pages/notification_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  // Needed to
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure that Firebase is connected to our application
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Initialize the notifications from Firebase
  await FirebaseApi().initNotifications();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      navigatorKey: navigatorKey,
      routes: {'/notification_screen': (context) => const NotificationPage()},
    );
  }
}
