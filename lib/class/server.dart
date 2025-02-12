import 'package:flutter/material.dart';
import 'package:sched_master/class/institution.dart';
import 'package:sched_master/class/schedule.dart';
import 'package:sched_master/class/teacher.dart';

class Server extends ChangeNotifier {
  Institution institution = Institution(type: "", town: "", id: "0", name: "", replacement: false, schedule: false);
  List<Teacher> teacher = [];
  List<Schedule> schedule = [];

  Future<bool> loadData(ServerData serverData) async {
    try {
      institution = serverData.institution;
      teacher = serverData.teacher;
      schedule = serverData.scheduleData;

      notifyListeners();
      return true;
    } catch(e) {
      return false;
    }
  }
}

class ServerData {
  final Institution institution;
  final List<Teacher> teacher;
  final List<Schedule> scheduleData;

  ServerData({required this.institution, required this.teacher, required this.scheduleData});
}
