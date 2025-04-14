import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sched_master/class/institution.dart';
import 'package:sched_master/class/server.dart';
import 'package:sched_master/class/replacements_history.dart';
import 'package:sched_master/class/theme_provider.dart';

import 'package:sched_master/services/server.dart';

import 'package:sched_master/screen/error_screen.dart';
import 'package:sched_master/screen/loading_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Institution? selectedInstitution;
  bool isBannerAlreadyCreated = false;

  @override
  void initState() {
    super.initState();
    _loadInstitution();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _loadInstitution() async {
    selectedInstitution ??= Provider.of<Server>(context, listen: false).institution;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDarkTheme ? Colors.grey[900] : const Color.fromRGBO(245, 245, 245, 1),
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
        title: Text(
          'История замен',
          style: TextStyle(
            fontSize: 20,
            color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: themeProvider.isDarkTheme ? Colors.white : Colors.black),
            onPressed: () => _refresh(context),
          ),
        ],
      ),
      body: FutureBuilder<List<ReplacementHistory>>(
        future: getHistoryReplacement(selectedInstitution!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return ErrorScreen(onRefresh: () => _refresh(context));
          }

          final replacements = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: replacements.length,
                  itemBuilder: (context, index) {
                    final day = replacements[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          color: themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 5,
                          child: ExpansionTile(
                            tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                            title: Text(
                              'Замены на ${day.data} (${day.day})',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.isDarkTheme ? Colors.white : const Color(0xFF404040),
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const _TableHeader(),
                                    Divider(color: themeProvider.isDarkTheme ? Colors.grey[600] : Colors.grey, thickness: 1),
                                    ...List.generate(
                                      day.replacement.length,
                                      (i) => _ReplacementRow(
                                        replacement: day.replacement[i],
                                        previousGroup: i > 0 ? day.replacement[i - 1].group : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _refresh(BuildContext context) {
    setState(() {});
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _HeaderCell(label: 'Группа', flex: 2),
        _HeaderCell(label: 'Пара', flex: 2),
        _HeaderCell(label: 'На что заменили', flex: 3),
        _HeaderCell(label: 'Что заменили', flex: 3),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final int flex;

  const _HeaderCell({required this.label, required this.flex});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Expanded(
      flex: flex,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: themeProvider.isDarkTheme ? Colors.white70 : const Color.fromRGBO(155, 155, 155, 1),
        ),
      ),
    );
  }
}

class _ReplacementRow extends StatelessWidget {
  final ReplacementDocument replacement;
  final String? previousGroup;

  const _ReplacementRow({required this.replacement, this.previousGroup});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    bool shouldShowBorder = previousGroup != null &&
        previousGroup != replacement.group &&
        replacement.group != '-//-';

    return Column(
      children: [
        if (shouldShowBorder)
          Divider(color: themeProvider.isDarkTheme ? Colors.grey[600] : Colors.grey, thickness: 1),
        Row(
          children: [
            _CellText(content: replacement.group, flex: 2),
            _CellText(content: replacement.number, flex: 2),
            _CellText(content: replacement.newLabel, flex: 3),
            _CellText(content: replacement.oldLabel, flex: 3),
          ],
        ),
      ],
    );
  }
}

class _CellText extends StatelessWidget {
  final String content;
  final int flex;

  const _CellText({required this.content, required this.flex});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Expanded(
      flex: flex,
      child: Text(
        content,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}