import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sched_master/class/theme_provider.dart';

class ErrorScreen extends StatelessWidget {
  final VoidCallback onRefresh;

  const ErrorScreen({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDarkTheme ? Colors.grey[900] : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/error.png",
              width: 300,
              height: 300,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRefresh,
              icon: Icon(
                Icons.refresh,
                size: 24,
                color: themeProvider.isDarkTheme ? Colors.white : Colors.white,
              ),
              label: Text(
                "Обновить",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: themeProvider.isDarkTheme ? Colors.white : Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: themeProvider.isDarkTheme ? Colors.grey[800] : const Color.fromARGB(255, 137, 137, 137),
                foregroundColor: themeProvider.isDarkTheme ? Colors.white : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                shadowColor: themeProvider.isDarkTheme ? Colors.black45 : Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}