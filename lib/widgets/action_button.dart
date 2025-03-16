import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sched_master/class/theme_provider.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback? onPressed;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AnimatedOpacity(
      opacity: enabled ? 1.0 : 0.5,
      duration: const Duration(milliseconds: 300),
      child: ElevatedButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: Icon(
          icon,
          color: themeProvider.isDarkTheme ? Colors.white : Colors.white,
        ),
        label: Text(
          label,
          style: TextStyle(
            color: themeProvider.isDarkTheme ? Colors.white : Colors.white,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 6,
          shadowColor: themeProvider.isDarkTheme ? Colors.black45 : Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: enabled
              ? themeProvider.isDarkTheme ? Colors.grey[800] : Colors.black
              : themeProvider.isDarkTheme ? Colors.grey[700] : const Color.fromARGB(255, 138, 138, 138),
        ),
      ),
    );
  }
}