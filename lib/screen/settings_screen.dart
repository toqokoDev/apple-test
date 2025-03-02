import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
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

    if (await hasInternetConnection()) {
      await sendTokenToServer(value, _selectedInstitution!);
      await _sendQueuedRequests();
    } else {
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
    if (_isLoading) {
      return const LoadingScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Настройки',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if(_selectedInstitution!.replacement)
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SwitchListTile(
                      title: const Text(
                        'Уведомления о заменах',
                        style: TextStyle(fontSize: 16),
                      ),
                      value: _notificationsEnabled,
                      onChanged: _toggleNotifications,
                      activeColor: Colors.white,
                      activeTrackColor: Colors.black,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    )
                  ]
                )
              ),
            if(_selectedInstitution!.replacement)
              const SizedBox(height: 20),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                title: const Text(
                  'Выбранное заведение',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "${_selectedInstitution!.name} (${_selectedInstitution!.town})",
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.red),
                  onPressed: _changeInstitution,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if(_selectedInstitution!.history)
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: ListTile(
                  title: const Text(
                    'История замен',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Просмотр предыдущих замен в расписании.',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.history, color: Colors.orange),
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
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                title: const Text(
                  'О приложении',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'Приложение помогает отслеживать расписание и замены в удобном формате.',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.blue),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text('Наши соцсети', textAlign: TextAlign.center),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Подписывайтесь на нас, чтобы быть в курсе всех новостей!',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: const FaIcon(FontAwesomeIcons.xTwitter, size: 30),
                                    onPressed: () => launchURL('https://x.com/toqoko'),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.telegram, size: 30),
                                    onPressed: () => launchURL('https://t.me/sched_master'),
                                  ),
                                  IconButton(
                                    icon: const FaIcon(FontAwesomeIcons.github, size: 30),
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
    );
  }
}
