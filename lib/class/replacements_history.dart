class ReplacementHistory {
  final String data;
  final String day;
  final List<ReplacementDocument> replacement;

  ReplacementHistory({
    required this.data,
    required this.day,
    required this.replacement,
  });

  factory ReplacementHistory.fromJson(Map<String, dynamic> json) {
    return ReplacementHistory(
      data: json['data'] as String,
      day: json['day'] as String,
      replacement: (json['replacement'] as List<dynamic>)
          .map((item) => ReplacementDocument.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'day': day,
      'replacement': replacement.map((day) => day.toJson()).toList(),
    };
  }
}

class ReplacementDocument {
  final String group;
  final String number;
  final String oldLabel;
  final String newLabel;
  final String newAudience;
  final String teachers;

  ReplacementDocument({
    required this.group,
    required this.number,
    required this.oldLabel,
    required this.newLabel,
    required this.newAudience,
    required this.teachers,
  });

  factory ReplacementDocument.fromJson(Map<String, dynamic> json) {
    return ReplacementDocument(
      group: json['group'] as String,
      number: json['number'] as String,
      oldLabel: json['old_label'] as String,
      newLabel: json['new_label'] as String,
      newAudience: json['new_audience'] as String,
      teachers: (json['teachers'] as List<dynamic>).join(", "),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group': group,
      'number': number,
      'old_label': oldLabel,
      'new_label': newLabel,
      'new_audience': newAudience,
      'teachers': teachers.split(","),
    };
  }
}
