import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sched_master/class/institution.dart';
import 'package:sched_master/class/server.dart';
import 'package:sched_master/class/teacher.dart';
import 'package:sched_master/class/teacher_replacements.dart';

import 'package:sched_master/constants/api.dart';

import 'package:sched_master/class/schedule.dart';
import 'package:sched_master/class/replacements.dart';

Future<List<Schedule>> getGroupData() async {
  try {
    final response = await http.get(
      Uri.parse(Api.getScheduleData),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );
    final String responseBody = utf8.decode(response.bodyBytes);
    final List<dynamic> responseData = json.decode(responseBody);

    return responseData.map((data) => Schedule.fromJson(data)).toList();
  } catch (e) {
    throw Exception('Failed to Group load data');
  }
}

Future<List<Replacements>> getReplacement(String group) async {
  try {
    final response = await http.get(
      Uri.parse("${Api.getReplacementData}?group=$group"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );

    final String responseBody = utf8.decode(response.bodyBytes);
    final List<dynamic> responseData = json.decode(responseBody);

    return responseData.map((data) => Replacements.fromJson(data)).toList();
  } catch (e) {
    throw Exception('Failed to Replacement load data');
  }
}

Future<List<Teacher>> getTeacherData() async {
  try {
    final response = await http.get(
      Uri.parse(Api.getTeacherData),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );
    final String responseBody = utf8.decode(response.bodyBytes);
    final List<dynamic> responseData = json.decode(responseBody);

    return responseData.map((data) => Teacher.fromJson(data)).toList();
  } catch (e) {
    throw Exception('Failed to Teacher load data');
  }
}

Future<Institution> getInstitutionData(String institutionID) async {
  try {
    final response = await http.get(
      Uri.parse("${Api.getInstitution}?id=$institutionID"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );

    final String responseBody = utf8.decode(response.bodyBytes);
    final dynamic responseData = json.decode(responseBody);

    return Institution.fromJson(responseData);
  } catch (e) {
    throw Exception('Failed to Institution load data');
  }
}

Future<ServerData?> getData(String institutionID) async {
  try {
    Institution institution = await getInstitutionData(institutionID);
    List<Schedule> schedules = await getGroupData();
    List<Teacher> teachers = await getTeacherData();

    return ServerData(institution: institution, scheduleData: schedules, teacher: teachers);
  } catch (e) {
    return null; 
  }
}

Future<List<TeacherReplacements>> getTeacherReplacement(String name) async {
  try {
    final response = await http.get(
      Uri.parse("${Api.getTeacherReplacementData}?teacher=$name"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );

    final String responseBody = utf8.decode(response.bodyBytes);
    final List<dynamic> responseData = json.decode(responseBody);

    return responseData.map((data) => TeacherReplacements.fromJson(data)).toList();
  } catch (e) {
    throw Exception('Failed to Teacher Replacement load data');
  }
}

Future<List<Institution>> loadInstitutions() async {
  try {
    final response = await http.get(
      Uri.parse(Api.getInstitutionData),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );

    final String responseBody = utf8.decode(response.bodyBytes);
    final List<dynamic> responseData = json.decode(responseBody);

    return responseData.map((data) => Institution.fromJson(data)).toList();
  } catch (e) {
    throw Exception('Failed to Institutions load data');
  }
}
