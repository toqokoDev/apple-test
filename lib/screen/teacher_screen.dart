import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sched_master/class/server.dart';
import 'package:sched_master/class/teacher.dart';
import 'package:sched_master/class/teacher_replacements.dart';

import 'package:sched_master/widgets/teacher_select.dart';

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
      body: DropDownTeacherSetting(
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
                    unselectedLabelColor: Colors.black,
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

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          '${par.number} пара',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(64, 64, 64, 1),
                          ),
                        ),
                      ),
                      Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: par.lessons.map((lesson) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                child: Text(
                                                  lesson.time,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Container(
                                                width: 2.0,
                                                height: 20.0,
                                                color: const Color.fromRGBO(194, 194, 194, 1),
                                              ),
                                              const SizedBox(width: 13.0),
                                              Flexible(
                                                child: Text(
                                                  lesson.up.label,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          lesson.up.audience,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                    unselectedLabelColor: Colors.black,
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
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Замены на ${day.data}(${day.day})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(64, 64, 64, 1),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Пара',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(155, 155, 155, 1),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'На что заменили',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(155, 155, 155, 1),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Что заменили',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(155, 155, 155, 1),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Ауд.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(155, 155, 155, 1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              color: Color.fromRGBO(194, 194, 194, 1),
                              thickness: 1,
                            ),
                            Column(
                              children: List.generate(day.replacement.length, (index) {
                                final replacement = day.replacement[index];
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              replacement[1],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              replacement[3],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              replacement[5],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              replacement[2],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (index != day.replacement.length - 1)
                                      const Divider(
                                        color: Color.fromRGBO(219, 219, 220, 1),
                                        thickness: 1,
                                      ),
                                  ],
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Расписание на “${day.day}” с учетом замен',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(64, 64, 64, 1),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: day.schedule.pars.length,
                          itemBuilder: (context, index) {
                            final par = day.schedule.pars[index];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: par.lessons.map((lesson) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                child: Text(
                                                  lesson.time,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                                const SizedBox(width: 10.0),
                                                Container(
                                                  width: 2.0,
                                                  height: 20.0,
                                                  color: const Color.fromRGBO(194, 194, 194, 1),
                                                ),
                                                const SizedBox(width: 13.0),
                                                Flexible(
                                                  child: Text(
                                                    lesson.up.label,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            lesson.up.audience,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                                if (index < day.schedule.pars.length - 1)
                                  const Divider(
                                    color: Colors.grey,
                                    thickness: 1.0,
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
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
