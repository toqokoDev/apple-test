import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sched_master/class/theme_provider.dart';

class ReplacementCard extends StatelessWidget {
  final dynamic day;

  const ReplacementCard({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Card(
      color: themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Пара',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.isDarkTheme ? Colors.grey[400] : const Color.fromRGBO(155, 155, 155, 1),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'На что заменили',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.isDarkTheme ? Colors.grey[400] : const Color.fromRGBO(155, 155, 155, 1),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Что заменили',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.isDarkTheme ? Colors.grey[400] : const Color.fromRGBO(155, 155, 155, 1),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Ауд.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.isDarkTheme ? Colors.grey[400] : const Color.fromRGBO(155, 155, 155, 1),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: themeProvider.isDarkTheme ? Colors.grey[600] : const Color.fromRGBO(194, 194, 194, 1),
              thickness: 1,
            ),
            Column(
              children: List.generate(day.replacement.length, (index) {
                final replacement = day.replacement[index];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              replacement.number,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              replacement.newLabel,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              replacement.oldLabel,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              replacement.newAudience,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (index != day.replacement.length - 1)
                      Divider(
                        color: themeProvider.isDarkTheme ? Colors.grey[600] : const Color.fromRGBO(219, 219, 220, 1),
                        thickness: 1,
                      ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}