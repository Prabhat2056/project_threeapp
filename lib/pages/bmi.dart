import 'package:flutter/material.dart';

class Bmi  extends StatelessWidget {
  const Bmi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'BMI Calculator Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}