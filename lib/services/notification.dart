import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void setupFirebaseMessaging() {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  messaging.requestPermission();

  messaging.getToken().then((token) {
    print("FCM Token: $token");
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    showNotification(message);
  });
}

Future<void> showNotification(RemoteMessage message) async {
  var androidDetails = const AndroidNotificationDetails(
    'channelId', 'channelName',
    importance: Importance.high,
    priority: Priority.high,
    icon: '@drawable/ic_notification',
  );

  var notificationDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0, 
    message.notification?.title ?? "Без заголовка", 
    message.notification?.body ?? "Без текста", 
    notificationDetails
  );
}
