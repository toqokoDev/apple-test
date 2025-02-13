// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sched_master/class/server.dart';
import 'package:sched_master/screen/error_screen.dart';
import 'package:sched_master/screen/loading_screen.dart';
import 'package:sched_master/screen/settings_screen.dart';

import 'package:sched_master/screen/student_screen.dart';
import 'package:sched_master/screen/teacher_screen.dart';
import 'package:sched_master/services/server.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;
  bool isLoading = true;
  bool hasError = false;
  late ServerData? serverData;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String selectedInstitutionID = prefs.getString('selectedInstitutionID') ?? "0";

      serverData = await getData(selectedInstitutionID);
      Provider.of<Server>(context, listen: false).loadData(serverData!);
      
      setState(() {
        isLoading = false;
        hasError = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingScreen();
    } else if (hasError) {
      return ErrorScreen(onRefresh: loadData);
    }
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      body: Center(
        child: _selectedIndex == 1 ? const StudentScreen() : _selectedIndex == 2 ? const SettingScreen() : const TeacherScreen(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/state/teacher.png',
              width: 32,
              height: 32,
            ),
            activeIcon: Image.asset(
              'assets/icons/active/teacher.png',
              width: 32,
              height: 32,
            ),
            label: 'Преподаватель',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/state/student.png',
              width: 32,
              height: 32,
            ),
            activeIcon: Image.asset(
              'assets/icons/active/student.png',
              width: 32,
              height: 32,
            ),
            label: 'Студент',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/state/settings.png',
              width: 32,
              height: 32,
            ),
            activeIcon: Image.asset(
              'assets/icons/active/settings.png',
              width: 32,
              height: 32,
            ),
            label: 'Настройки',
          )
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: const Color.fromRGBO(130, 130, 130, 1),
        selectedItemColor: const Color.fromRGBO(0, 0, 0, 1),
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedFontSize: 13,
        unselectedFontSize: 13,
      ),
    );
  }
}
