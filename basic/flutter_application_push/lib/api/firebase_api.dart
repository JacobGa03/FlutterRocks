import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_application_push/main.dart';

class FirebaseApi {
  // Create an instance of Firebase messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize notifications
  Future<void> initNotifications() async {
    // Request permissions from the user
    await _firebaseMessaging.requestPermission();

    // fetch FCM token from the device (needed to send notifications)
    final fcmToken = await _firebaseMessaging.getToken();
    print('token: ${fcmToken.toString()}');
    // initialize the push notification
    initPushNotifications();
  }

  // function to handle received messages
  void handleMessage(RemoteMessage? message) {
    // There is no message
    if (message == null) return;
    // Navigate to other screen if user taps the message
    navigatorKey.currentState
        ?.pushNamed('/notification_screen', arguments: message);
  }

  // Foreground and background settings
  Future initPushNotifications() async {
    // Handle notifications if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    // Attach event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
