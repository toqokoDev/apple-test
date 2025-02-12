import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            Image.asset(
              "assets/error.png",
              width: 300,
              height: 300,
            ),
          ]
        ),
      ),
    );
  }
}
