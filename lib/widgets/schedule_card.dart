import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final dynamic day;

  const ScheduleCard({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  children: par.lessons.map<Widget>((lesson) {
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
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
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
    );
  }
}
