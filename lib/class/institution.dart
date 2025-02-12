class Institution {
  final String id;
  final String name;
  final String type;
  final String town;
  final bool replacement;
  final bool schedule;

  Institution({
    required this.id,
    required this.name,
    required this.type,
    required this.town, 
    required this.replacement, 
    required this.schedule
    });

  factory Institution.fromJson(Map<String, dynamic> json) {
    return Institution(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      town: json['town'] as String,
      replacement: json['replacement'] as bool,
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
      'schedule': schedule
    };
  }
}