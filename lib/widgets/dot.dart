import 'package:flutter/material.dart';

class Dot extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const Dot({
    required this.size,
    required this.color,
    required this.opacity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
