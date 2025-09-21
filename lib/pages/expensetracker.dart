import 'package:flutter/material.dart';
class ExpenseTracker extends StatelessWidget {
  const ExpenseTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Expense Tracker Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}