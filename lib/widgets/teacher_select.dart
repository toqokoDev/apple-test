import 'package:flutter/material.dart';
import 'package:sched_master/class/teacher.dart';
import 'package:sched_master/class/teacher_replacements.dart';
import 'package:sched_master/services/server.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sched_master/screen/loading_screen.dart';
import 'package:sched_master/screen/error_screen.dart';


class DropDownTeacherSetting extends StatefulWidget {
  final List<Teacher> data;
  final Widget Function(Teacher) scheduleScreen;
  final Widget Function(List<TeacherReplacements>) replacementsScreen;

  const DropDownTeacherSetting({
    super.key,
    required this.data,
    required this.scheduleScreen,
    required this.replacementsScreen,
  });

  @override
  State<DropDownTeacherSetting> createState() => _DropDownTeacherSettingState();
}

class _DropDownTeacherSettingState extends State<DropDownTeacherSetting> {
  String? selectedTeacher;
  bool _isLoading = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _loadSelectedGroup();
  }

  Future<void> _loadSelectedGroup() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedTeacher = prefs.getString('selectedTeacher');
    });
  }

  Future<void> _saveSelectedGroup(String? group) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTeacher', group ?? '');
  }

  Future<void> _handleButtonPress() async {
    if (selectedTeacher == null) return;

    setState(() => _isLoading = true);

    try {
      List<TeacherReplacements> replacements = await getTeacherReplacement(selectedTeacher!);

      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => widget.replacementsScreen(replacements),
          ),
        );
      }
    } catch (error) {
      setState(() => _isError = true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: LoadingScreen());
    } else if (_isError) {
      return const Center(child: ErrorScreen());
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            'Выберите преподавателя:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromRGBO(103, 103, 103, 1)),
          ),
          const SizedBox(height: 5),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: DropdownButton<String>(
                value: selectedTeacher,
                isExpanded: true,
                hint: const Text('Выберите преподавателя'),
                underline: const SizedBox.shrink(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTeacher = newValue;
                  });
                  _saveSelectedGroup(newValue);
                },
                items: widget.data.map<DropdownMenuItem<String>>((Teacher teacher) {
                  return DropdownMenuItem<String>(
                    value: teacher.name,
                    child: Text(teacher.name),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          AnimatedOpacity(
            opacity: selectedTeacher != null ? 1.0 : 0.5,
            duration: const Duration(milliseconds: 300),
            child: ElevatedButton.icon(
              onPressed: selectedTeacher != null
                  ? () {
                      final scheduleTeacher = widget.data.firstWhere(
                        (scheduleTeacher) => scheduleTeacher.name == selectedTeacher,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => widget.scheduleScreen(scheduleTeacher),
                        ),
                      );
                    }
                  : null,
              icon: const Icon(Icons.schedule, color: Colors.white),
              label: const Text(
                'Получить расписание',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 6,
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: selectedTeacher != null ? Colors.black : Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 20),
          AnimatedOpacity(
            opacity: selectedTeacher != null ? 1.0 : 0.5,
            duration: const Duration(milliseconds: 300),
            child: ElevatedButton.icon(
              onPressed: selectedTeacher != null
                  ? () async {
                      _handleButtonPress();
                    }
                  : null,
              icon: const Icon(Icons.update, color: Colors.white),
              label: const Text('Получить замены', style: TextStyle(color: Colors.white, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 6,
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: selectedTeacher != null ? Colors.black : Colors.grey,
              ),
            ),
          )
        ],
      ),
    );
  }
}
