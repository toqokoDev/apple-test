import 'package:flutter/material.dart';
import 'package:sched_master/class/institution.dart';
import 'package:sched_master/screen/error_screen.dart';
import 'package:sched_master/screen/loading_screen.dart';
import 'package:sched_master/services/server.dart';
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
          .where((institution) => institution.name.toLowerCase().contains(query.toLowerCase()))
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
    if (isLoading) {
      return const LoadingScreen();
    } else if (hasError) {
      return const ErrorScreen();
    } else {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text(
            'Выберите заведение',
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey[600]),
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
                          selectedInstitution =
                              isSelected ? null : institution;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color.fromARGB(255, 0, 0, 0) : Colors.white,
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
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${institution.type} г. ${institution.town}',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                color: isSelected ? Colors.white70 : Colors.grey[600],
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
                    backgroundColor: selectedInstitution != null ? Colors.black : Colors.grey[400],
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