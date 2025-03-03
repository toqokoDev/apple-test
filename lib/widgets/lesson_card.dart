import 'package:flutter/material.dart';

class LessonCard extends StatelessWidget {
  final List<dynamic> lessons;
  final DateTime currentTime;
  final bool isCurrentDay;

  const LessonCard({
    super.key,
    required this.lessons,
    required this.currentTime,
    required this.isCurrentDay,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: lessons.map((lesson) {
                final lessonTime = parseTime(lesson.time.split("-")[0]);
                final lessonEndTime = lessonTime.add(const Duration(minutes: 45));
                final currentOnlyTime = DateTime(0, 0, 0, currentTime.hour, currentTime.minute);
                final isCurrentTime = currentOnlyTime.isAfter(lessonTime) && currentOnlyTime.isBefore(lessonEndTime);

                final isCurrentLesson = isCurrentDay && isCurrentTime;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: isCurrentLesson
                          ? const LinearGradient(
                              colors: [Colors.blueAccent, Colors.lightBlue],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: isCurrentLesson ? const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0) : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              SizedBox(
                                child: Text(
                                  lesson.time,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isCurrentLesson ? Colors.white : Colors.black,
                                    fontWeight: isCurrentLesson ? FontWeight.bold : FontWeight.normal,
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
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      if (lesson.group != null && lesson.group!.isNotEmpty)
                                        TextSpan(
                                          text: '(${lesson.group}) ',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color.fromARGB(255, 129, 129, 129),
                                          ),
                                        ),
                                      TextSpan(
                                        text: lesson.label,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isCurrentLesson ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                            ],
                          ),
                        ),
                        Text(
                          lesson.audience,
                          style: TextStyle(
                            fontSize: 14,
                            color: isCurrentLesson ? Colors.white : Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

DateTime parseTime(String time) {
  final parts = time.split(':');
  return DateTime(0, 0, 0, int.parse(parts[0]), int.parse(parts[1]));
}
