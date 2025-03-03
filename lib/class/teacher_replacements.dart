import 'package:sched_master/class/teacher.dart';

class ReplacementTeacherDocument {
  final String number;
  final String oldLabel;
  final String newLabel;
  final String newAudience;
  final String teachers;

  ReplacementTeacherDocument({
    required this.number,
    required this.oldLabel,
    required this.newLabel,
    required this.newAudience,
    required this.teachers,
  });

  factory ReplacementTeacherDocument.fromJson(Map<String, dynamic> json) {
    return ReplacementTeacherDocument(
      number: json['number'] as String,
      oldLabel: json['old_label'] as String,
      newLabel: json['new_label'] as String,
      newAudience: json['new_audience'] as String,
      teachers: (json['teachers'] as List<dynamic>).join(", "),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'old_label': oldLabel,
      'new_label': newLabel,
      'new_audience': newAudience,
      'teachers': teachers.split(","),
    };
  }
}

class TeacherReplacements {
  final String name;
  final String data;
  final String day;
  final Day schedule;
  final String description;
  final List<ReplacementTeacherDocument> replacement;

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
          .map((item) => ReplacementTeacherDocument.fromJson(item as Map<String, dynamic>))
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
      'replacement': replacement.map((day) => day.toJson()).toList()
    };
  }
}
