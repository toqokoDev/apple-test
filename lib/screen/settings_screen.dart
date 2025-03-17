import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sched_master/class/theme_provider.dart';
import 'package:sched_master/screen/history_screen.dart';
import 'package:sched_master/services/server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:sched_master/class/institution.dart';
import 'package:sched_master/class/server.dart';
import 'package:sched_master/utils/ethernet.dart';

import 'package:sched_master/screen/institution_screen.dart';
import 'package:sched_master/screen/loading_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late Box<bool> notificationQueue;
  bool _notificationsEnabled = false;
  Institution? _selectedInstitution;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadSettings();
      await _initHiveQueue();
      _sendQueuedRequests();
    });
  }

  Future<void> _initHiveQueue() async {
    if (!Hive.isBoxOpen('notificationQueue')) {
      await Hive.openBox<bool>('notificationQueue');
    }
    notificationQueue = Hive.box<bool>('notificationQueue');
  }

  Future<void> _loadSettingsStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() {
      _notificationsEnabled = value;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notificationsEnabled', value);

    try {
      await sendTokenToServer(value, _selectedInstitution!);
      await _sendQueuedRequests();
    } catch(e) {
      saveToQueue(value);
    }
  }

  Future<void> saveToQueue(bool enabled) async {
    await notificationQueue.add(enabled);
  }

  Future<void> _sendQueuedRequests() async {
    if (await hasInternetConnection()) {
      while (notificationQueue.isNotEmpty) {
        bool status = notificationQueue.getAt(0)!;
        await sendTokenToServer(status, _selectedInstitution!);
        notificationQueue.deleteAt(0);
      }
    }
  }

  Future<void> _loadSettings() async {
    await Future.delayed(const Duration(seconds: 1));
    _selectedInstitution = Provider.of<Server>(context, listen: false).institution;

    _loadSettingsStatus();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _changeInstitution() async {
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SelectInstitutionScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (_isLoading) {
      return const LoadingScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Настройки',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
      ),
      backgroundColor: themeProvider.isDarkTheme ? Colors.grey[900] : const Color.fromRGBO(245, 245, 245, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: ListTile(
                  title: Text(
                    'Темная тема',
                    style: TextStyle(
                      fontSize: 16,
                      color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      themeProvider.toggleTheme(!themeProvider.isDarkTheme);
                    },
                    child: Switch(
                      value: themeProvider.isDarkTheme,
                      onChanged: null,
                      activeColor: themeProvider.isDarkTheme ? Colors.grey[900] : Colors.white,
                      activeTrackColor: themeProvider.isDarkTheme ? Colors.grey : Colors.black,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                )
              ),
              const SizedBox(height: 20),
              if(_selectedInstitution!.replacement)
                Card(
                  color: themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      'Уведомления о заменах',
                      style: TextStyle(
                        fontSize: 16,
                        color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: () => _toggleNotifications(!_notificationsEnabled),
                      child: Switch(
                        value: _notificationsEnabled,
                        onChanged: null,
                        activeColor: themeProvider.isDarkTheme ? Colors.grey[900] : Colors.white,
                        activeTrackColor: themeProvider.isDarkTheme ? Colors.grey : Colors.black,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  )
                ),
              if(_selectedInstitution!.replacement)
                const SizedBox(height: 20),
              Card(
                color: themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: ListTile(
                  title: Text(
                    'Выбранное заведение',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: themeProvider.isDarkTheme ? Colors.white : Colors.black),
                  ),
                  subtitle: Text(
                    "${_selectedInstitution!.name} (${_selectedInstitution!.town})",
                    style: TextStyle(fontSize: 13, color: themeProvider.isDarkTheme ? Colors.white70 : Colors.black54),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: themeProvider.isDarkTheme ? Colors.red[300] : Colors.red),
                    onPressed: _changeInstitution,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if(_selectedInstitution!.history)
                Card(
                  color: themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      'История замен',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: themeProvider.isDarkTheme ? Colors.white : Colors.black),
                    ),
                    subtitle: Text(
                      'Просмотр предыдущих замен в расписании.',
                      style: TextStyle(fontSize: 14, color: themeProvider.isDarkTheme ? Colors.white70 : Colors.black54),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.history, color: themeProvider.isDarkTheme ? Colors.orange[300] : Colors.orange),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HistoryScreen()),
                        );
                      },
                    ),
                  ),
                ),
              if(_selectedInstitution!.history)
                const SizedBox(height: 20),
              Card(
                color: themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: ListTile(
                  title: Text(
                    'О приложении',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: themeProvider.isDarkTheme ? Colors.white : Colors.black),
                  ),
                  subtitle: Text(
                    'Приложение помогает отслеживать расписание и замены в удобном формате.',
                    style: TextStyle(fontSize: 14, color: themeProvider.isDarkTheme ? Colors.white70 : Colors.black54),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.info_outline, color: themeProvider.isDarkTheme ? Colors.blue[300] : Colors.blue),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
                            title: Text('Наши соцсети', textAlign: TextAlign.center, style: TextStyle(color: themeProvider.isDarkTheme ? Colors.white : Colors.black)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Подписывайтесь на нас, чтобы быть в курсе всех новостей!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: themeProvider.isDarkTheme ? Colors.white70 : Colors.black54),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      icon: FaIcon(FontAwesomeIcons.xTwitter, size: 30, color: themeProvider.isDarkTheme ? Colors.white : Colors.black),
                                      onPressed: () => launchURL('https://x.com/toqoko'),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.telegram, size: 30, color: themeProvider.isDarkTheme ? Colors.white : Colors.black),
                                      onPressed: () => launchURL('https://t.me/sched_master'),
                                    ),
                                    IconButton(
                                      icon: FaIcon(FontAwesomeIcons.github, size: 30, color: themeProvider.isDarkTheme ? Colors.white : Colors.black),
                                      onPressed: () => launchURL('https://github.com/toqokoDev'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}