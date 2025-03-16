import 'package:hive/hive.dart';
part 'favorite.g.dart';

@HiveType(typeId: 0)
class Favorite {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final bool isTeacher;

  Favorite({required this.name, required this.isTeacher});
}
