import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sched_master/class/favorite.dart';
import 'package:sched_master/class/theme_provider.dart';
import 'package:sched_master/services/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:sched_master/class/server.dart';
import 'package:sched_master/screen/main_screen.dart';
import 'package:sched_master/screen/institution_screen.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.initialize();

  setupFirebaseMessaging();

  var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await Hive.initFlutter();
  await Hive.openBox<bool>('notificationQueue');
  Hive.registerAdapter(FavoriteAdapter());
  await Hive.openBox('favorites'); // Открытие бокса

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? selectedInstitution = prefs.getString('selectedInstitutionID');
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Server>(
          create: (context) => Server(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      routes: {
        '/main': (context) => const MainScreen(),
      },
      title: 'SchedMaster',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: showSelectInstitution 
          ? const SelectInstitutionScreen()
          : const MainScreen(),
    );
  }
}
