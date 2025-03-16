import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sched_master/class/favorite.dart';
import 'package:sched_master/class/theme_provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final Box favoritesBox = Hive.box('favorites');
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
          title: Text(
            'Избранное',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          bottom: TabBar(
            indicatorColor: themeProvider.isDarkTheme ? Colors.white : Colors.black,
            labelColor: themeProvider.isDarkTheme ? Colors.white : Colors.black,
            tabs: const [
              Tab(text: 'Преподаватели'),
              Tab(text: 'Группы'),
            ],
          ),
        ),
        backgroundColor: themeProvider.isDarkTheme ? Colors.grey[900] : const Color.fromRGBO(245, 245, 245, 1),
        body: TabBarView(
          children: [
            _buildTeacherList(themeProvider),
            _buildStudentList(themeProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherList(ThemeProvider themeProvider) {
    final teachers = favoritesBox.values
        .where((favorite) => favorite.isTeacher)
        .toList();

    return ListView.builder(
      itemCount: teachers.length,
      itemBuilder: (context, index) {
        return _buildListItem(teachers[index], themeProvider);
      },
    );
  }

  Widget _buildStudentList(ThemeProvider themeProvider) {
    final groups = favoritesBox.values
        .where((favorite) => !favorite.isTeacher)
        .toList();

    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        return _buildListItem(groups[index], themeProvider);
      },
    );
  }

  Widget _buildListItem(Favorite favorite, ThemeProvider themeProvider) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      decoration: BoxDecoration(
        color: themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            favorite.name,
            style: TextStyle(
              fontSize: 16,
              color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.calendar_today, color: themeProvider.isDarkTheme ? Colors.white : Colors.black),
                onPressed: () {
                  // Действие для получения расписания
                },
              ),
              IconButton(
                icon: Icon(Icons.swap_horiz, color: themeProvider.isDarkTheme ? Colors.white : Colors.black),
                onPressed: () {
                  // Действие для получения замен
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
