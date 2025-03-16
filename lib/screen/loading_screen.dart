import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sched_master/class/theme_provider.dart';
import 'package:sched_master/widgets/dot.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<Offset>> _positionAnimations;

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

    _scaleAnimations = List.generate(3, (index) {
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(
          index * 0.2,
          1.0,
          curve: Curves.elasticOut,
        ),
      );
    });

    _positionAnimations = List.generate(3, (index) {
      return Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0.0, -0.2),
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.2,
            1.0,
            curve: Curves.elasticOut,
          ),
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDarkTheme ? Colors.grey[900] : const Color.fromRGBO(245, 245, 245, 1),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _animations[index],
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimations[index].value * 1.2,
                  child: Opacity(
                    opacity: _animations[index].value,
                    child: SlideTransition(
                      position: _positionAnimations[index],
                      child: Dot(
                        size: 10.0,
                        color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
                        opacity: 1.0,
                      ),
                    ),
                  ),
                );
              },
            );
          }).expand((widget) => [widget, const SizedBox(width: 15.0)]).toList()..removeLast(),
        ),
      ),
    );
  }
}