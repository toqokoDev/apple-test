import 'package:flutter/material.dart';

import 'package:sched_master/widgets/dot.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animations = List.generate(3, (index) {
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(
          index * 0.2,
          1.0,
          curve: Curves.easeInOut,
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _animations[index],
              builder: (context, child) {
                return Opacity(
                  opacity: _animations[index].value,
                  child: const Dot(size: 10.0, color: Colors.black, opacity: 1.0),
                );
              },
            );
          }).expand((widget) => [widget, const SizedBox(width: 10.0)]).toList()..removeLast(),
        ),
      ),
    );
  }
}
