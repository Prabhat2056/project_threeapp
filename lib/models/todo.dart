

// class ToDo {
//   String id;
//   String? todoText;
//   bool isDone;

//   ToDo({
//     this.id,
//     required this.todoText,
//     this.isDone = false,
//   });

//   static List<ToDo> todoList() {
//     return [
//       ToDo(
//         id: '01',
//         todoText: 'Complete Flutter project',
//         isDone: false,
//       ),
//       ToDo(
//         id: '02',
//         todoText: 'Read a book',
//         isDone: true,
//       ),
//       ToDo(
//         id: '03',
//         todoText: 'Go for a walk',
//         isDone: false,
//       ),
//       ToDo(
//         id: '04',
//         todoText: 'Prepare dinner',
//         isDone: true,
//       ),
//     ];

//   }
// }

// class ToDo {
//   final String id;           // ✅ Must be non-null and final
//   final String? todoText;
//   bool isDone;
//   DateTime date; 

//   ToDo({
//     required this.id,
//     required this.todoText,
//     this.isDone = false,
//     required this.date,
//   });

//   static List<ToDo> todoList() {
//     return [
      
//     ];
//   }
// }

//import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:project_etb/pages/mylist.dart';

class ToDo {
  String id;
  String todoText;
  bool isDone;
  DateTime date;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
    required this.date,
  });

  factory ToDo.fromMap(Map<String, dynamic> map, String id) {
    return ToDo(
      id: id,
      todoText: map['todoText'] ?? '',
      isDone: map['isDone'] ?? false,
      date: (map['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'todoText': todoText,
      'isDone': isDone,
      'date': Timestamp.fromDate(date),
    };
  }
}
