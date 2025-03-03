import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sched_master/class/institution.dart';
import 'package:sched_master/class/server.dart';
import 'package:sched_master/class/teacher.dart';
import 'package:sched_master/class/teacher_replacements.dart';
import 'package:sched_master/services/server.dart';
import 'package:sched_master/widgets/action_button.dart';
import 'package:sched_master/screen/loading_screen.dart';
import 'package:sched_master/screen/error_screen.dart';

class DropDownTeacher extends StatefulWidget {
  final List<Teacher> data;
  final Widget Function(Teacher) scheduleScreen;
  final Widget Function(List<TeacherReplacements>) replacementsScreen;

  const DropDownTeacher({
    super.key,
    required this.data,
    required this.scheduleScreen,
    required this.replacementsScreen,
  });

  @override
  State<DropDownTeacher> createState() => _DropDownTeacherState();
}

class _DropDownTeacherState extends State<DropDownTeacher> {
  String? selectedTeacher;
  bool _isLoading = false;
  bool _isError = false;
  Institution? selectedInstitution;

  @override
  void initState() {
    super.initState();
    _loadSelectedTeacher();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedInstitution ??= Provider.of<Server>(context, listen: false).institution;
  }

  Future<void> _loadSelectedTeacher() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => selectedTeacher = prefs.getString('selectedTeacher'));
  }

  Future<void> _saveSelectedTeacher(String teacher) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTeacher', teacher);
  }

  Future<void> _fetchReplacements() async {
    if (selectedTeacher == null || selectedInstitution == null) return;
    setState(() {_isLoading = true; _isError = false;});

    try {
      final replacements = await getTeacherReplacement(selectedTeacher!, selectedInstitution!);
      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget.replacementsScreen(replacements)),
        );
      }
    } catch (_) {
      if (mounted) setState(() => _isError = true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showTeacherSelectionScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _TeacherSelectionScreen(
          teachers: widget.data,
          initialSelection: selectedTeacher,
          onSelected: (teacher) {
            setState(() => selectedTeacher = teacher.name);
            _saveSelectedTeacher(teacher.name);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: LoadingScreen());
    if (_isError) return Center(child: ErrorScreen(onRefresh: _fetchReplacements));

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Выберите преподавателя: ",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(103, 103, 103, 1),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _showTeacherSelectionScreen,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        selectedTeacher ?? "Выберите преподавателя",
                        style: TextStyle(
                          color: selectedTeacher != null ? Colors.black : Colors.grey,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (selectedInstitution?.schedule ?? false)
              ActionButton(
                icon: Icons.schedule,
                label: 'Получить расписание',
                enabled: selectedTeacher != null,
                onPressed: () {
                  final teacher = widget.data.firstWhere((t) => t.name == selectedTeacher);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => widget.scheduleScreen(teacher)),
                  );
                },
              ),
            const SizedBox(height: 20),
            if (selectedInstitution?.replacement ?? false)
              ActionButton(
                icon: Icons.update,
                label: 'Получить замены',
                enabled: selectedTeacher != null,
                onPressed: _fetchReplacements,
              ),
          ],
        ),
      )
    );
  }
}

class _TeacherSelectionScreen extends StatefulWidget {
  final List<Teacher> teachers;
  final String? initialSelection;
  final Function(Teacher) onSelected;

  const _TeacherSelectionScreen({
    required this.teachers,
    required this.initialSelection,
    required this.onSelected,
  });

  @override
  _TeacherSelectionScreenState createState() => _TeacherSelectionScreenState();
}

class _TeacherSelectionScreenState extends State<_TeacherSelectionScreen> {
  TextEditingController searchController = TextEditingController();
  List<Teacher> filteredTeachers = [];

  @override
  void initState() {
    super.initState();
    filteredTeachers = List.from(widget.teachers);
  }

  void filterSearchResults(String query) {
    setState(() => filteredTeachers = widget.teachers
        .where((teacher) => teacher.name.toLowerCase().contains(query.toLowerCase()))
        .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      appBar: AppBar(
        title: const Text(
          'Выберите преподавателя',
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: searchController,
                onChanged: filterSearchResults,
                decoration: InputDecoration(
                hintText: 'Поиск...',
                hintStyle: TextStyle(fontFamily: 'Roboto', color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: filteredTeachers.length,
                separatorBuilder: (_, __) => Divider(color: Colors.grey[300]),
                itemBuilder: (context, index) {
                  final teacher = filteredTeachers[index];
                  return ListTile(
                    title: Text(teacher.name, style: const TextStyle(fontSize: 16)),
                    onTap: () {
                      widget.onSelected(teacher);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
