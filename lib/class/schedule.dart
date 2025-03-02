class Schedule {
  final String name;
  final String type;
  final List<Day> days;

  Schedule({required this.name, required this.type, required this.days});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      name: json['name'] as String,
      type: json['type'] as String,
      days: (json['days'] as List<dynamic>).map((day) => Day.fromJson(day as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'days': days.map((day) => day.toJson()).toList(),
    };
  }
}

class Day {
  final String name;
  final List<Par> pars;

  Day({required this.name, required this.pars});

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      name: json['name'] as String,
      pars: (json['pars'] as List<dynamic>).map((par) => Par.fromJson(par as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'pars': pars.map((par) => par.toJson()).toList(),
    };
  }
}

class Par {
  final String name;
  final List<Lesson> lessons;

  Par({required this.name, required this.lessons});

  factory Par.fromJson(Map<String, dynamic> json) {
    return Par(
      name: json['name'] as String,
      lessons: (json['lessons'] as List<dynamic>).map((lesson) => Lesson.fromJson(lesson as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
    };
  }
}

class Lesson {
  final String label;
  final String audience;
  final String teachers;
  Null group;
  final String time;

  Lesson({required this.label, required this.audience, required this.teachers, required this.time});

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      label: json['label'] as String,
      audience: json['audience'] as String,
      teachers: json['teachers'].join(", ") as String,
      time: json['time'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'audience': audience,
      'teachers': teachers.split(","),
      'time': time
    };
  }
}
