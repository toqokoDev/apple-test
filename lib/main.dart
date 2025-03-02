import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sched_master/services/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:sched_master/class/server.dart';
import 'package:sched_master/screen/main_screen.dart';
import 'package:sched_master/screen/institution_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  setupFirebaseMessaging();

  var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await Hive.initFlutter();
  await Hive.openBox<bool>('notificationQueue');

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? selectedInstitution = prefs.getString('selectedInstitutionID');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Server>(
          create: (context) => Server(),
        ),
      ],
      child: MyApp(showSelectInstitution: selectedInstitution == null),
    ),
  );
}


class MyApp extends StatelessWidget {
  final bool showSelectInstitution;
  
  const MyApp({super.key, required this.showSelectInstitution});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/main': (context) => const MainScreen(),
      },
      title: 'SchedMaster',
      home: showSelectInstitution 
          ? const SelectInstitutionScreen()
          : const MainScreen(),
    );
  }
}
