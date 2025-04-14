import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sched_master/class/favorite.dart';
import 'package:sched_master/class/institution.dart';
import 'package:sched_master/class/server.dart';
import 'package:sched_master/class/theme_provider.dart';
import 'package:sched_master/constants/ad.dart';
import 'package:sched_master/screen/error_screen.dart';
import 'package:sched_master/screen/loading_screen.dart';
import 'package:sched_master/screen/student_screen.dart';
import 'package:sched_master/screen/teacher_screen.dart';
import 'package:sched_master/services/server.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool _isLoading = false;
  bool _isError = false;
  Institution? selectedInstitution;
  late final Future<InterstitialAdLoader> _adLoader;
  InterstitialAd? _ad;
  final Box favoritesBox = Hive.box('favorites');

  @override
  void initState() {
    super.initState();
    _adLoader = _createInterstitialAdLoader();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedInstitution ??= Provider.of<Server>(context, listen: false).institution;
    _loadInterstitialAd();
  }

  Future<InterstitialAdLoader> _createInterstitialAdLoader() {
    return InterstitialAdLoader.create(
      onAdLoaded: (InterstitialAd interstitialAd) {
        _ad = interstitialAd;
      },
      onAdFailedToLoad: (error) {
        // Handle ad load failure
      },
    );
  }

  Future<void> _loadInterstitialAd() async {
    final adLoader = await _adLoader;
    await adLoader.loadAd(adRequestConfiguration: const AdRequestConfiguration(adUnitId: Advertising.interstitialID));
  }

  Future<void> _showAd() async {
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

  Future<void> _handleGroupReplacements(String name) async {
    if (selectedInstitution == null) return;
    setState(() => _isLoading = true);

    try {
      final replacements = await getReplacement(name, selectedInstitution!);

      await _showAd();

      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReplacementsGroupWatchScreen(replacements)),
        );
      }
    } catch (_) {
      setState(() => _isError = true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleTeacherReplacements(String name) async {
    if (selectedInstitution == null) return;
    setState(() => _isLoading = true);

    try {
      final replacements = await getTeacherReplacement(name, selectedInstitution!);

      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReplacementsTeacherWatchScreen(replacements)),
        );
      }
    } catch (_) {
      setState(() => _isError = true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isError = false;
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: LoadingScreen());
    if (_isError) return Center(child: ErrorScreen(onRefresh: _refreshData));

    final themeProvider = Provider.of<ThemeProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
          title: Text(
            'Избранное',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          bottom: TabBar(
            indicatorColor: themeProvider.isDarkTheme ? Colors.white : Colors.black,
            labelColor: themeProvider.isDarkTheme ? Colors.white : Colors.black,
            tabs: const [
              Tab(text: 'Преподаватели'),
              Tab(text: 'Группы'),
            ],
          ),
        ),
        backgroundColor: themeProvider.isDarkTheme ? Colors.grey[900] : const Color.fromRGBO(245, 245, 245, 1),
        body: TabBarView(
          children: [
            _buildTeacherList(themeProvider),
            _buildStudentList(themeProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherList(ThemeProvider themeProvider) {
    final teachers = favoritesBox.values
        .where((favorite) => favorite.isTeacher)
        .toList();

    return ListView.builder(
      itemCount: teachers.length,
      itemBuilder: (context, index) {
        final scheduleData = Provider.of<Server>(context).teacher;
        final scheduleTeacher = scheduleData.firstWhere((s) => s.name == teachers[index].name);

        return _buildListItem(
          teachers[index],
          themeProvider,
          TeacherWatchScreen(scheduleTeacher),
          () => _handleTeacherReplacements(teachers[index].name),
        );
      },
    );
  }

  Widget _buildStudentList(ThemeProvider themeProvider) {
    final groups = favoritesBox.values
        .where((favorite) => !favorite.isTeacher)
        .toList();

    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final scheduleData = Provider.of<Server>(context).schedule;
        final scheduleGroup = scheduleData.firstWhere((s) => s.name == groups[index].name);

        return _buildListItem(
          groups[index],
          themeProvider,
          ScheduleWatchScreen(scheduleGroup),
          () => _handleGroupReplacements(groups[index].name),
        );
      },
    );
  }

  Widget _buildListItem(Favorite favorite, ThemeProvider themeProvider, Widget scheduleScreen, VoidCallback onReplacementPressed) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      decoration: BoxDecoration(
        color: themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            favorite.name,
            style: TextStyle(
              fontSize: 16,
              color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.calendar_today, color: themeProvider.isDarkTheme ? Colors.white : Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => scheduleScreen),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.update, color: themeProvider.isDarkTheme ? Colors.white : Colors.black),
                onPressed: onReplacementPressed,
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: themeProvider.isDarkTheme ? Colors.orange : Colors.red,
                ),
                onPressed: () {
                  _removeFavorite(favorite);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  void _removeFavorite(Favorite favorite) {
    final key = favoritesBox.keys.firstWhere((key) => favoritesBox.get(key).name == favorite.name);
    favoritesBox.delete(key);

    setState(() {});
  }
}