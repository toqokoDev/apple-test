import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sched_master/class/theme_provider.dart';

class ErrorScreen extends StatelessWidget {
  final VoidCallback onRefresh;

  const ErrorScreen({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkTheme = themeProvider.isDarkTheme;

    return Scaffold(
      backgroundColor: isDarkTheme ? Colors.grey[900] : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Анимированная иконка ошибки
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Image.asset(
                isDarkTheme ? "assets/error/black.png" : "assets/error/white.png",
                width: 300,
                height: 300,
                key: ValueKey<bool>(isDarkTheme), // Для анимации переключения
              ),
            ),
            const SizedBox(height: 20),
            // Текст с описанием ошибки
            Text(
              "Упс! Что-то пошло не так",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkTheme ? Colors.white : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Попробуйте обновить страницу",
              style: TextStyle(
                fontSize: 16,
                color: isDarkTheme ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: isDarkTheme
                      ? [Colors.blue[800]!, Colors.blue[600]!]
                      : [Colors.blue[600]!, Colors.blue[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ElevatedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(
                  Icons.refresh,
                  size: 24,
                  color: Colors.white,
                ),
                label: const Text(
                  "Обновить",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
