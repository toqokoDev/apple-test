import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:sched_master/class/favorite.dart';
import 'package:sched_master/constants/ad.dart';
import 'package:yandex_mobileads/mobile_ads.dart';
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
  String? selectedType;
  String? selectedGroup;
  bool _isLoading = false;
  bool _isError = false;
  Institution? selectedInstitution;
  late final Future<InterstitialAdLoader> _adLoader;
  InterstitialAd? _ad;
  final Box _favoritesBox = Hive.box('favorites');

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedInstitution ??= Provider.of<Server>(context, listen: false).institution;
    _adLoader = _createInterstitialAdLoader();
    _loadInterstitialAd();
  }

  Future<InterstitialAdLoader> _createInterstitialAdLoader() {
    return InterstitialAdLoader.create(
      onAdLoaded: (InterstitialAd interstitialAd) {
        _ad = interstitialAd;
      },
      onAdFailedToLoad: (error) {},
    );
  }

  Future<void> _loadInterstitialAd() async {
    final adLoader = await _adLoader;
    await adLoader.loadAd(adRequestConfiguration: const AdRequestConfiguration(adUnitId: Advertising.interstitialID));
  }

  _showAd() async {
    _ad?.setAdEventListener(
      eventListener: InterstitialAdEventListener(
        onAdShown: () {},
        onAdFailedToShow: (error) {
          _ad?.destroy();
          _ad = null;

          _loadInterstitialAd();
        },
        onAdClicked: () {},
        onAdDismissed: () {
          _ad?.destroy();
          _ad = null;

          _loadInterstitialAd();
        },
        onAdImpression: (impressionData) {},
      )
    );
    await _ad?.show();
    await _ad?.waitForDismiss();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedType = prefs.getString('selectedCourse');
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

      await _showAd();

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

  void _toggleFavorite() {
    if (selectedGroup == null) return;

    final person = Favorite(name: selectedGroup!, isTeacher: false);
    final isFavorite = _favoritesBox.values.any((item) => item.name == selectedGroup);

    if (isFavorite) {
      final key = _favoritesBox.keys.firstWhere((key) => _favoritesBox.get(key).name == selectedGroup);
      _favoritesBox.delete(key);
    } else {
      _favoritesBox.add(person);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: LoadingScreen());
    if (_isError) return Center(child: ErrorScreen(onRefresh: _handleReplacements));

    final types = widget.data.map((item) => item.type).toSet().toList();
    final filteredGroups = widget.data.where((s) => selectedType == null || s.type == selectedType).toList();

    final isFavorite = selectedGroup != null && _favoritesBox.values.any((item) => item.name == selectedGroup);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomDropdown(
              label: 'Выберите курс:',
              value: selectedType,
              items: types,
              onChanged: (value) {
                setState(() {
                  selectedType = value;
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
              enabled: selectedType == null ? false : true,
            ),

            const SizedBox(height: 20),
            
            if (selectedGroup != null) 
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: isFavorite ? Colors.red[100] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey[700],
                  ),
                  title: Text(
                    isFavorite ? 'В избранном' : 'Добавить в избранное',
                    style: TextStyle(
                      color: isFavorite ? Colors.red[900] : Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey[600],
                    size: 16,
                  ),
                  onTap: _toggleFavorite,
                ),
              ),

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
            
            const SizedBox(height: 15),
            
            if (selectedInstitution?.replacement ?? false) ActionButton(
              icon: Icons.update,
              label: 'Получить замены',
              enabled: selectedGroup != null,
              onPressed: _handleReplacements
            ),
          ],
        ),
      )
    );
  }
}