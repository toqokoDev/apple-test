import 'package:sched_master/class/schedule.dart';

class ReplacementDocument {
  final String number;
  final String oldLabel;
  final String newLabel;
  final String newAudience;
  final String teachers;

  ReplacementDocument({
    required this.number,
    required this.oldLabel,
    required this.newLabel,
    required this.newAudience,
    required this.teachers,
  });

  factory ReplacementDocument.fromJson(Map<String, dynamic> json) {
    return ReplacementDocument(
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

class Replacements {
  final String group;
  final String data;
  final String day;
  final String description;
  final Day schedule;
  final List<ReplacementDocument> replacement;

  Replacements({
    required this.group,
    required this.data,
    required this.day,
    required this.schedule,
    required this.description,
    required this.replacement,
  });

  factory Replacements.fromJson(Map<String, dynamic> json) {
    return Replacements(
      description: json['description'] as String,
      group: json['group'] as String,
      data: json['data'] as String,
      day: json['day'] as String,
      schedule: Day.fromJson(json['schedule'] as Map<String, dynamic>),
      replacement: (json['replacement'] as List<dynamic>)
          .map((item) => ReplacementDocument.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'group': group,
      'data': data,
      'day': day,
      'schedule': schedule.toJson(),
      'replacement': replacement.map((item) => item.toJson()).toList(),
    };
  }
}
