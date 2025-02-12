import 'package:sched_master/class/schedule.dart';

class Replacements {
  final String group;
  final String data;
  final String day;
  final String description;
  // final String institution;
  final Day schedule;
  final List<List<String>> replacement;

  Replacements({
    required this.group,
    required this.data,
    required this.day,
    required this.schedule,
    required this.description,
    // required this.institution,
    required this.replacement,
  });

  factory Replacements.fromJson(Map<String, dynamic> json) {
    return Replacements(
      description: json['description'] as String,
      group: json['group'] as String,
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
      // 'institution': institution,
      'description': description,
      'group': group,
      'data': data,
      'day': day,
      'schedule': schedule.toJson(),
      'replacement': replacement.map((day) => day.toList()).toList(),
    };
  }
}
