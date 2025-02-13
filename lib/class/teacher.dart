class Teacher {
  final String name;
  final List<Day> days;

  Teacher({required this.name, required this.days});

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      name: json['name'] as String,
      days: (json['days'] as List<dynamic>).map((day) => Day.fromJson(day as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
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
  final num number;
  final List<Lesson> lessons;

  Par({required this.number, required this.lessons});

  factory Par.fromJson(Map<String, dynamic> json) {
    return Par(
      number: json['number'] as num,
      lessons: (json['lessons'] as List<dynamic>).map((lesson) => Lesson.fromJson(lesson as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
    };
  }
}

class Lesson {
  final String label;
  final String audience;
  final String group;
  final String time;

  Lesson({required this.label, required this.audience, required this.group, required this.time});

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      label: json['label'] as String,
      audience: json['audience'] as String,
      group: json['group'] as String,
      time: json['time'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'audience': audience,
      'group': group,
      'time': time
    };
  }
}
