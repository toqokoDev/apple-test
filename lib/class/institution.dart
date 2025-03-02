class Institution {
  final String id;
  final String name;
  final String type;
  final String town;
  final num timeLesson;
  final bool replacement;
  final bool history;
  final bool schedule;

  Institution({
    required this.id,
    required this.name,
    required this.type,
    required this.town, 
    required this.timeLesson, 
    required this.replacement, 
    required this.history,
    required this.schedule
    });

  factory Institution.fromJson(Map<String, dynamic> json) {
    return Institution(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      town: json['town'] as String,
      timeLesson: json['time_lesson'] as num,
      replacement: json['replacement'] as bool,
      history: json['history'] as bool,
      schedule: json['schedule'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'town': town,
      'replacement': replacement,
      'history': history,
      'schedule': schedule
    };
  }
}