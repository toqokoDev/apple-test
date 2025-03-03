import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:sched_master/class/institution.dart';
import 'package:sched_master/class/replacements_history.dart';
import 'package:sched_master/class/server.dart';
import 'package:sched_master/class/teacher.dart';
import 'package:sched_master/class/teacher_replacements.dart';

import 'package:sched_master/constants/api.dart';

import 'package:sched_master/class/schedule.dart';
import 'package:sched_master/class/replacements.dart';

Future<List<Schedule>> getGroupData(Institution institution) async {
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

Future<List<ReplacementHistory>> getHistoryReplacement(Institution institution) async {
  try {
    final response = await http.get(
      Uri.parse(Api.getHistoryReplacement),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );
    final String responseBody = utf8.decode(response.bodyBytes);
    final List<dynamic> responseData = json.decode(responseBody);

    return responseData.map((data) => ReplacementHistory.fromJson(data)).toList();
  } catch (e) {
    throw Exception('Failed to History load data');
  }
}

Future<List<Replacements>> getReplacement(String group, Institution institution) async {
  try {
    final response = await http.post(
      Uri.parse(Api.getReplacementData),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: json.encode({"group": group})
    );

    final String responseBody = utf8.decode(response.bodyBytes);
    final List<dynamic> responseData = json.decode(responseBody);

    return responseData.map((data) => Replacements.fromJson(data)).toList();
  } catch (e) {
    throw Exception('Failed to Replacement load data');
  }
}

Future<List<Teacher>> getTeacherData(Institution institution) async {
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
    final response = await http.post(
      Uri.parse(Api.getInstitution),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: json.encode({"id": institutionID})
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
    List<Schedule> schedules = await getGroupData(institution);
    List<Teacher> teachers = await getTeacherData(institution);

    return ServerData(institution: institution, scheduleData: schedules, teacher: teachers);
  } catch (e) {
    return null; 
  }
}

Future<List<TeacherReplacements>> getTeacherReplacement(String name, Institution institution) async {
  try {
    final response = await http.post(
      Uri.parse(Api.getTeacherReplacementData),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: json.encode({"teacher": name})
    );

    final String responseBody = utf8.decode(response.bodyBytes);
    final List<dynamic> responseData = json.decode(responseBody);
    print(responseData);
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

Future<void> sendTokenToServer(bool enabled, Institution institution) async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final String? token = await messaging.getToken();

  try {
    final response = await http.post(
      Uri.parse(Api.getSaveToken),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: json.encode({
        "token": token,
        "status": enabled ? "enabled" : "disabled",
        "institutionID": institution.id
      }),
    );

    final String responseBody = utf8.decode(response.bodyBytes);
    final Map<String, dynamic> responseData = json.decode(responseBody);

    if (responseData["status"] == "error") {
      throw Exception("❌ Ошибка при сохранении токена");
    }
  } catch (e) {
    throw Exception("❌ Ошибка при сохранении токена");
  }
}

Future<void> sendDeleteRequestToServer() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final String? token = await messaging.getToken();

  try {
    final response = await http.post(
      Uri.parse(Api.getDeleteToken),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: json.encode({
        "token": token,
      }),
    );

    final String responseBody = utf8.decode(response.bodyBytes);
    final Map<String, dynamic> responseData = json.decode(responseBody);

    if (responseData["status"] == "error") {
      throw Exception("❌ Ошибка при удалении токена");
    }
  } catch (e) {
    throw Exception("❌ Ошибка при удалении токена");
  }
}
