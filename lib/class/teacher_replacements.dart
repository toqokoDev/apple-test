import 'package:sched_master/class/teacher.dart';

class TeacherReplacements {
  // final String institution;
  final String name;
  final String data;
  final String day;
  final Day schedule;
  final List<List<String>> replacement;

  TeacherReplacements({
    required this.name,
    required this.data,
    required this.day,
    required this.schedule,
    required this.replacement,
    // required this.institution
  });

  factory TeacherReplacements.fromJson(Map<String, dynamic> json) {
    return TeacherReplacements(
      name: json['name'] as String,
      data: json['data'] as String,
      day: json['day'] as String,
      // institution: json['institution'] as String,
      schedule: Day.fromJson(json['schedule'] as Map<String, dynamic>),
      replacement: (json['replacement'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((s) => s as String).toList())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'data': data,
      'day': day,
      // 'institution': institution,
      'schedule': schedule.toJson(),
      'replacement': replacement.map((day) => day.toList()).toList()
    };
  }
}
