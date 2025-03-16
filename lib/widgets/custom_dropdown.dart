import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sched_master/class/theme_provider.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  const CustomDropdown({
    super.key,
    required this.label,
    this.value,
    required this.items,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: themeProvider.isDarkTheme ? Colors.white70 : const Color.fromRGBO(103, 103, 103, 1),
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: themeProvider.isDarkTheme ? Colors.white70 : Colors.grey,
          ),
          hint: Text(
            label.replaceAll(":", ""),
            style: TextStyle(
              color: themeProvider.isDarkTheme ? Colors.white70 : Colors.grey,
            ),
          ),
          onChanged: enabled ? onChanged : null,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  color: enabled
                      ? themeProvider.isDarkTheme ? Colors.white : Colors.black
                      : Colors.grey,
                ),
              ),
            );
          }).toList(),
          dropdownColor: themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
        ),
      ],
    );
  }
}