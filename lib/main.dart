import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sched_master/class/server.dart';
import 'package:sched_master/screen/institution_screen.dart';

import 'package:sched_master/screen/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(70, 168, 248, 1),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: showSelectInstitution 
          ? const SelectInstitutionScreen()
          : const MainScreen(),
    );
  }
}
