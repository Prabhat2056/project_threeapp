import 'package:flutter/material.dart';
class ToDoList extends StatelessWidget {
  const ToDoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'To-Do List Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}