import 'package:flutter/material.dart';

class FavoriteTile extends StatelessWidget {
  final bool isFavorite;
  final bool isDarkTheme;
  final VoidCallback onTap;

  const FavoriteTile({
    Key? key,
    required this.isFavorite,
    required this.isDarkTheme,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isDarkTheme
        ? (isFavorite ? Colors.blue.withOpacity(0.2) : Colors.grey.withOpacity(0.1))
        : (isFavorite ? Colors.blue.withOpacity(0.1) : Colors.grey.withOpacity(0.1));

    final Color iconColor = isDarkTheme
        ? (isFavorite ? Colors.blue[200]! : Colors.grey[400]!)
        : (isFavorite ? Colors.blue : Colors.grey[700]!);

    final Color textColor = isDarkTheme
        ? (isFavorite ? Colors.blue[100]! : Colors.grey[300]!)
        : (isFavorite ? Colors.blue[900]! : Colors.grey[800]!);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: isDarkTheme
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkTheme
                ? (isFavorite ? Colors.blue.withOpacity(0.3) : Colors.grey.withOpacity(0.2))
                : (isFavorite ? Colors.blue.withOpacity(0.2) : Colors.grey.withOpacity(0.2)),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isFavorite ? Icons.bookmark : Icons.bookmark_border,
            color: iconColor,
            size: 24,
          ),
        ),
        title: Text(
          isFavorite ? 'В избранном' : 'Добавить в избранное',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}