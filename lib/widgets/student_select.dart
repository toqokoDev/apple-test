import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sched_master/class/replacements.dart';
import 'package:sched_master/class/schedule.dart';

import 'package:sched_master/services/server.dart';

import 'package:sched_master/screen/loading_screen.dart';
import 'package:sched_master/screen/error_screen.dart';

List<String> courses = ['Первый курс', 'Второй курс', 'Третий курс', 'Четвертый курс'];

class DropDownStudentSetting extends StatefulWidget {
  final List<Schedule> data;
  final Widget Function(Schedule) scheduleScreen;
  final Widget Function(List<Replacements>) replacementsScreen;

  const DropDownStudentSetting({
    super.key,
    required this.data,
    required this.scheduleScreen,
    required this.replacementsScreen,
  });

  @override
  State<DropDownStudentSetting> createState() => _DropDownStudentSettingState();
}

class _DropDownStudentSettingState extends State<DropDownStudentSetting> {
  String? selectedCourse;
  String? selectedGroup;
  bool _isLoading = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _loadSelectedCourse();
    _loadSelectedGroup();
  }

  Future<void> _loadSelectedCourse() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCourse = prefs.getString('selectedCourse');
    });
  }

  Future<void> _loadSelectedGroup() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedGroup = prefs.getString('selectedGroup');
    });
  }

  Future<void> _saveSelectedCourse(String? course) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCourse', course ?? '');
  }

  Future<void> _saveSelectedGroup(String? group) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedGroup', group ?? '');
  }

  Future<void> _handleButtonPress() async {
    if (selectedGroup == null) return;

    setState(() => _isLoading = true);

    try {
      List<Replacements> replacements = await getReplacement(selectedGroup!);

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

    List<Schedule> filteredGroups = widget.data
        .where((schedule) => selectedCourse == null || schedule.course == selectedCourse)
        .toList();
        
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            'Выберите раздел:',
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
                value: selectedCourse,
                isExpanded: true,
                hint: const Text('Выберите раздел'),
                underline: const SizedBox.shrink(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCourse = newValue;
                    selectedGroup = null;
                  });
                  _saveSelectedCourse(newValue);
                },
                items: courses.map<DropdownMenuItem<String>>((String course) {
                  return DropdownMenuItem<String>(
                    value: course,
                    child: Text(course),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Выберите группу:',
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
                value: selectedGroup,
                isExpanded: true,
                hint: const Text('Выберите группу'),
                underline: const SizedBox.shrink(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGroup = newValue;
                  });
                  _saveSelectedGroup(newValue);
                },
                items: filteredGroups.map<DropdownMenuItem<String>>((Schedule group) {
                  return DropdownMenuItem<String>(
                    value: group.group,
                    child: Text(group.group),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          AnimatedOpacity(
            opacity: selectedGroup != null ? 1.0 : 0.5,
            duration: const Duration(milliseconds: 300),
            child: ElevatedButton.icon(
              onPressed: selectedGroup != null
                  ? () {
                      final scheduleGroup = widget.data.firstWhere(
                        (scheduleGroup) => scheduleGroup.group == selectedGroup,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => widget.scheduleScreen(scheduleGroup),
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
                backgroundColor: selectedGroup != null ? Colors.black : Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 20),
          AnimatedOpacity(
            opacity: selectedGroup != null ? 1.0 : 0.5,
            duration: const Duration(milliseconds: 300),
            child: ElevatedButton.icon(
              onPressed: selectedGroup != null
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
                backgroundColor: selectedGroup != null ? Colors.black : Colors.grey,
              ),
            ),
          )
        ],
      ),
    );
  }
}
