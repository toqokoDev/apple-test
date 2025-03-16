import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sched_master/class/institution.dart';
import 'package:sched_master/class/theme_provider.dart';
import 'package:sched_master/screen/error_screen.dart';
import 'package:sched_master/screen/loading_screen.dart';
import 'package:sched_master/services/server.dart';
import 'package:sched_master/utils/ethernet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectInstitutionScreen extends StatefulWidget {
  const SelectInstitutionScreen({super.key});

  @override
  _SelectInstitutionScreenState createState() => _SelectInstitutionScreenState();
}

class _SelectInstitutionScreenState extends State<SelectInstitutionScreen> {
  Institution? selectedInstitution;
  TextEditingController searchController = TextEditingController();
  List<Institution> filteredInstitutions = [];
  List<Institution> institutions = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    loadInstitutionsData();
  }

  void loadInstitutionsData() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      final notificationQueue = Hive.box<bool>('notificationQueue');

      if (notificationQueue.isNotEmpty) {
        notificationQueue.clear();
      }

      final favorites = Hive.box('favorites');

      if (favorites.isNotEmpty) {
        favorites.clear();
      }

      await sendDeleteRequestToServer();

      institutions = await loadInstitutions();

      setState(() {
        filteredInstitutions = List.from(institutions);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  Future<void> saveSelectedInstitution(Institution institution) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedInstitutionID', institution.id);
  }

  void filterSearchResults(String query) {
    setState(() {
      selectedInstitution = null;
      filteredInstitutions = institutions
          .where((institution) => institution.name.toLowerCase().contains(query.toLowerCase()) || institution.town.toLowerCase().contains(query.toLowerCase()) || institution.type.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void clearSearch() {
    setState(() {
      selectedInstitution = null;
      searchController.clear();
      filteredInstitutions = List.from(institutions);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (isLoading) {
      return const LoadingScreen();
    } else if (hasError) {
      return ErrorScreen(onRefresh: loadInstitutionsData);
    } else {
      return Scaffold(
        backgroundColor: themeProvider.isDarkTheme ? Colors.grey[900] : const Color.fromRGBO(245, 245, 245, 1),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Выберите заведение',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: Icon(Icons.info, color: themeProvider.isDarkTheme ? Colors.white : Colors.black, size: 30.0),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: Text(
                          'Не нашли заведение?',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: themeProvider.isDarkTheme ? Colors.white : Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                'Напишите нам в Telegram, и мы добавим его!',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, color: themeProvider.isDarkTheme ? Colors.white70 : Colors.black87),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.telegram, color: themeProvider.isDarkTheme ? Colors.blue[300] : Colors.blueAccent, size: 50.0),
                                  onPressed: () => launchURL('https://t.me/sched_master'),
                                ),
                                Text(
                                  'Связаться в Telegram',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: themeProvider.isDarkTheme ? Colors.white70 : Colors.black54),
                                ),
                              ],
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              foregroundColor: themeProvider.isDarkTheme ? Colors.white : Colors.black,
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            child: const Text('Закрыть'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          backgroundColor: themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
          elevation: 0.5,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: searchController,
                onChanged: filterSearchResults,
                decoration: InputDecoration(
                  hintText: 'Поиск...',
                  hintStyle: TextStyle(fontFamily: 'Roboto', color: themeProvider.isDarkTheme ? Colors.white70 : Colors.grey[600]),
                  filled: true,
                  fillColor: themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: themeProvider.isDarkTheme ? Colors.white70 : Colors.grey[600]),
                          onPressed: clearSearch,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredInstitutions.length,
                  itemBuilder: (context, index) {
                    Institution institution = filteredInstitutions[index];
                    bool isSelected = selectedInstitution == institution;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedInstitution = isSelected ? null : institution;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? themeProvider.isDarkTheme ? Colors.blueGrey[800] : const Color.fromARGB(255, 100, 142, 161)
                              : themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              institution.name,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : themeProvider.isDarkTheme ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${institution.type} г. ${institution.town}',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                color: isSelected ? Colors.white70 : themeProvider.isDarkTheme ? Colors.white70 : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedInstitution != null
                      ? () async {
                          await saveSelectedInstitution(selectedInstitution!);
                          Navigator.pushReplacementNamed(context, '/main');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedInstitution != null
                        ? themeProvider.isDarkTheme ? Colors.blueGrey[800] : Colors.black
                        : themeProvider.isDarkTheme ? Colors.grey[700] : Colors.grey[400],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Продолжить',
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}