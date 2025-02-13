import 'package:sched_master/class/teacher.dart';

class TeacherReplacements {
  final String name;
  final String data;
  final String day;
  final Day schedule;
  final String description;
  final List<List<String>> replacement;

  TeacherReplacements({
    required this.name,
    required this.data,
    required this.day,
    required this.schedule,
    required this.replacement,
    required this.description,
  });

  factory TeacherReplacements.fromJson(Map<String, dynamic> json) {
    return TeacherReplacements(
      description: json['description'] as String,
      name: json['name'] as String,
      data: json['data'] as String,
      day: json['day'] as String,
      schedule: Day.fromJson(json['schedule'] as Map<String, dynamic>),
      replacement: (json['replacement'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((s) => s as String).toList())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'name': name,
      'data': data,
      'day': day,
      'schedule': schedule.toJson(),
      'replacement': replacement.map((day) => day.toList()).toList()
    };
  }
}
