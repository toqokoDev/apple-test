import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sched_master/class/schedule.dart';
import 'package:sched_master/class/server.dart';
import 'package:sched_master/class/replacements.dart';
import 'package:sched_master/class/theme_provider.dart';

import 'package:sched_master/widgets/lesson_card.dart';
import 'package:sched_master/widgets/schedule_card.dart';
import 'package:sched_master/widgets/student_select.dart';
import 'package:sched_master/widgets/replacement_card.dart';
import 'package:sched_master/widgets/description_card.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final scheduleData = Provider.of<Server>(context).schedule;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
        title: Text(
          'Учащимся',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
          ),
        ),
      ),
      backgroundColor: themeProvider.isDarkTheme ? Colors.grey[900] : const Color.fromRGBO(245, 245, 245, 1),
      body: DropDownStudent(
        data: scheduleData,
        scheduleScreen: (scheduleData) => ScheduleWatchScreen(scheduleData),
        replacementsScreen: (replacementsData) => ReplacementsGroupWatchScreen(replacementsData),
      ),
    );
  }
}

class ScheduleWatchScreen extends StatelessWidget {
  final Schedule schedule;

  const ScheduleWatchScreen(this.schedule, {super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentTime = DateTime.now();
    final currentDay = currentTime.weekday;

    return DefaultTabController(
      length: schedule.days.length,
      child: Scaffold(
        backgroundColor: themeProvider.isDarkTheme ? Colors.grey[900] : const Color.fromRGBO(245, 245, 245, 1),
        appBar: AppBar(
          title: Text(
            'Расписание для ${schedule.name}',
            style: TextStyle(
              fontSize: 20,
              color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Container(
                  color: Colors.transparent,
                  child: TabBar(
                    tabs: schedule.days.map((day) => Tab(text: day.name)).toList(),
                    indicator: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    labelColor: themeProvider.isDarkTheme ? Colors.white : Colors.black,
                    unselectedLabelColor: themeProvider.isDarkTheme ? Colors.grey[400] : const Color.fromARGB(255, 132, 132, 132),
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: schedule.days.map((day) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
              child: ListView.builder(
                itemCount: day.pars.length,
                itemBuilder: (context, index) {
                  final par = day.pars[index];
                  final isCurrentDay = schedule.days.indexOf(day) + 1 == currentDay;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          par.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.isDarkTheme ? Colors.white : const Color.fromRGBO(64, 64, 64, 1),
                          ),
                        ),
                      ),
                      LessonCard(
                        lessons: par.lessons,
                        currentTime: currentTime,
                        isCurrentDay: isCurrentDay,
                      )
                    ],
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ReplacementsGroupWatchScreen extends StatelessWidget {
  final List<Replacements> replacements;

  const ReplacementsGroupWatchScreen(this.replacements, {super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return DefaultTabController(
      length: replacements.length,
      child: Scaffold(
        backgroundColor: themeProvider.isDarkTheme ? Colors.grey[900] : const Color.fromRGBO(245, 245, 245, 1),
        appBar: AppBar(
          title: Text(
            'Замены для ${replacements[0].group}',
            style: TextStyle(
              fontSize: 20,
              color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Container(
                  color: Colors.transparent,
                  child: TabBar(
                    tabs: replacements.map((day) => Tab(text: day.day)).toList(),
                    indicator: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    labelColor: themeProvider.isDarkTheme ? Colors.white : Colors.black,
                    unselectedLabelColor: themeProvider.isDarkTheme ? Colors.grey[400] : const Color.fromARGB(255, 132, 132, 132),
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: replacements.map((day) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Замены на ${day.data} (${day.day})',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.isDarkTheme ? Colors.white : const Color.fromRGBO(64, 64, 64, 1),
                        ),
                      ),
                    ),
                    if (day.replacement.isEmpty)
                      DescriptionCard(description: day.description)
                    else
                      ReplacementCard(day: day),
                    const SizedBox(height: 20),
                    if (day.schedule.pars.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Обновленное расписание',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.isDarkTheme ? Colors.white : const Color.fromRGBO(64, 64, 64, 1),
                          ),
                        ),
                      ),
                    if (day.schedule.pars.isNotEmpty) ScheduleCard(day: day)
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}