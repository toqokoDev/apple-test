import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sched_master/class/server.dart';
import 'package:sched_master/class/teacher.dart';
import 'package:sched_master/class/teacher_replacements.dart';

import 'package:sched_master/widgets/lesson_card.dart';
import 'package:sched_master/widgets/schedule_card.dart';
import 'package:sched_master/widgets/teacher_select.dart';
import 'package:sched_master/widgets/replacement_card.dart';
import 'package:sched_master/widgets/description_card.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  @override
  Widget build(BuildContext context) {
    final scheduleData = Provider.of<Server>(context).teacher;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Преподавателям',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      body: DropDownTeacher(
        data: scheduleData, 
        scheduleScreen: (scheduleData) => TeacherWatchScreen(scheduleData),
        replacementsScreen: (replacementsData) => ReplacementsWatchScreen(replacementsData),
      ),
    );
  }
}

class TeacherWatchScreen extends StatelessWidget {
  final Teacher schedule;

  const TeacherWatchScreen(this.schedule, {super.key});

  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now();
    final currentDay = currentTime.weekday;

    return DefaultTabController(
      length: schedule.days.length,
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
        appBar: AppBar(
          title: Text(
            'Расписание для ${schedule.name}',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
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
                    labelColor: Colors.black,
                    unselectedLabelColor: const Color.fromARGB(255, 132, 132, 132),
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
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(64, 64, 64, 1),
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

class ReplacementsWatchScreen extends StatelessWidget {
  final List<TeacherReplacements> replacements;

  const ReplacementsWatchScreen(this.replacements, {super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: replacements.length,
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
        appBar: AppBar(
          title: Text(
            'Замены для ${replacements[0].name}',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
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
                    labelColor: Colors.black,
                    unselectedLabelColor: const Color.fromARGB(255, 132, 132, 132),
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(64, 64, 64, 1),
                        ),
                      ),
                    ),
                    if (day.replacement.isEmpty)
                      DescriptionCard(description: day.description)
                    else
                      ReplacementCard(day: day),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Обновленное расписание',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(64, 64, 64, 1),
                        ),
                      ),
                    ),
                    ScheduleCard(day: day)
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
