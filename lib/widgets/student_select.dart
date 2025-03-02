import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sched_master/widgets/action_button.dart';
import 'package:sched_master/widgets/custom_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sched_master/class/institution.dart';
import 'package:sched_master/class/server.dart';
import 'package:sched_master/class/replacements.dart';
import 'package:sched_master/class/schedule.dart';
import 'package:sched_master/services/server.dart';
import 'package:sched_master/screen/loading_screen.dart';
import 'package:sched_master/screen/error_screen.dart';

class DropDownStudent extends StatefulWidget {
  final List<Schedule> data;
  final Widget Function(Schedule) scheduleScreen;
  final Widget Function(List<Replacements>) replacementsScreen;

  const DropDownStudent({
    super.key,
    required this.data,
    required this.scheduleScreen,
    required this.replacementsScreen,
  });

  @override
  State<DropDownStudent> createState() => _DropDownStudentState();
}

class _DropDownStudentState extends State<DropDownStudent> {
  String? selectedCourse;
  String? selectedGroup;
  bool _isLoading = false;
  bool _isError = false;
  Institution? selectedInstitution;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedInstitution ??= Provider.of<Server>(context, listen: false).institution;
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCourse = prefs.getString('selectedCourse');
      selectedGroup = prefs.getString('selectedGroup');
    });
  }

  Future<void> _savePreference(String key, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value ?? '');
  }

  Future<void> _handleReplacements() async {
    if (selectedGroup == null || selectedInstitution == null) return;
    setState(() => _isLoading = true);
    
    try {
      final replacements = await getReplacement(selectedGroup!, selectedInstitution!);

      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget.replacementsScreen(replacements)),
        );
      }
    } catch (_) {
      setState(() => _isError = true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: LoadingScreen());
    if (_isError) return Center(child: ErrorScreen(onRefresh: _handleReplacements));

    final filteredGroups = widget.data.where((s) => selectedCourse == null || s.type == selectedCourse).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomDropdown(
            label: 'Выберите курс:',
            value: selectedCourse,
            items: courses,
            onChanged: (value) {
              setState(() {
                selectedCourse = value;
                selectedGroup = null;
              });
              _savePreference('selectedCourse', value);
            },
            enabled: true,
          ),

          const SizedBox(height: 20),

          CustomDropdown(
            label: 'Выберите группу:',
            value: selectedGroup,
            items: filteredGroups.map((s) => s.name).toList(),
            onChanged: (value) {
              setState(() => selectedGroup = value);
              _savePreference('selectedGroup', value);
            },
            enabled: selectedCourse == null ? false : true,
          ),

          const SizedBox(height: 30),
          
          if (selectedInstitution?.schedule ?? false) ActionButton(
            icon: Icons.schedule,
            label: 'Получить расписание',
            enabled: selectedGroup != null,
            onPressed: () {
              final scheduleGroup = widget.data.firstWhere((s) => s.name == selectedGroup);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => widget.scheduleScreen(scheduleGroup)),
              );
            },
          ),
          
          const SizedBox(height: 20),
          
          if (selectedInstitution?.replacement ?? false) ActionButton(
            icon: Icons.update,
            label: 'Получить замены',
            enabled: selectedGroup != null,
            onPressed: _handleReplacements
          ),
        ],
      ),
    );
  }
}

const List<String> courses = ['Первый курс', 'Второй курс', 'Третий курс', 'Четвертый курс'];
