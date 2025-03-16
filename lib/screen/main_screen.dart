import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sched_master/class/server.dart';
import 'package:sched_master/class/theme_provider.dart';
import 'package:sched_master/screen/error_screen.dart';
import 'package:sched_master/screen/favorite_screen.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (isLoading) {
      return const LoadingScreen();
    } else if (hasError) {
      return ErrorScreen(onRefresh: loadData);
    }
    return Scaffold(
      backgroundColor: themeProvider.isDarkTheme ? Colors.grey[900] : const Color.fromRGBO(245, 245, 245, 1),
      body: Center(
        child: _selectedIndex == 0
            ? const TeacherScreen()
            : _selectedIndex == 1
                ? const StudentScreen()
                : _selectedIndex == 2
                    ? const FavoriteScreen()
                    : const SettingScreen(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/state/teacher.png',
              width: 24,
              height: 24,
              color: themeProvider.isDarkTheme ? Colors.white : const Color.fromRGBO(130, 130, 130, 1),
            ),
            activeIcon: Image.asset(
              'assets/icons/active/teacher.png',
              width: 24,
              height: 24,
              color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
            ),
            label: 'Преподаватель',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/state/student.png',
              width: 24,
              height: 24,
              color: themeProvider.isDarkTheme ? Colors.white : const Color.fromRGBO(130, 130, 130, 1),
            ),
            activeIcon: Image.asset(
              'assets/icons/active/student.png',
              width: 24,
              height: 24,
              color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
            ),
            label: 'Студент',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/state/favorite.png',
              width: 24,
              height: 24,
              color: themeProvider.isDarkTheme ? Colors.white : const Color.fromRGBO(130, 130, 130, 1),
            ),
            activeIcon: Image.asset(
              'assets/icons/active/favorite.png',
              width: 24,
              height: 24,
              color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
            ),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/state/settings.png',
              width: 24,
              height: 24,
              color: themeProvider.isDarkTheme ? Colors.white : const Color.fromRGBO(130, 130, 130, 1),
            ),
            activeIcon: Image.asset(
              'assets/icons/active/settings.png',
              width: 24,
              height: 24,
              color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
            ),
            label: 'Настройки',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: themeProvider.isDarkTheme ? Colors.white70 : const Color.fromRGBO(130, 130, 130, 1),
        selectedItemColor: themeProvider.isDarkTheme ? Colors.white : Colors.black,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedFontSize: 10,
        unselectedFontSize: 10,
      ),
    );
  }
}