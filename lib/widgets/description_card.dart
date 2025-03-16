import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sched_master/class/theme_provider.dart';

class DescriptionCard extends StatelessWidget {
  final String description;

  const DescriptionCard({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SizedBox(
      width: double.infinity,
      child: Card(
        color: themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}