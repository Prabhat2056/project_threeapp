import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:project_etb/pages/mylist.dart";

import "package:project_etb/pages/todo.dart";



class Todolist extends StatefulWidget {
  const Todolist({super.key});

  @override
  State<Todolist> createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  final _todoController = TextEditingController();
  String _searchKeyword = '';
  final CollectionReference _todoRef =
      FirebaseFirestore.instance.collection('todos');

  void _addToDoItem(String todoText) async {
    if (todoText.isEmpty) return;

    final newDoc = _todoRef.doc();
    final todo = ToDo(
      id: newDoc.id,
      todoText: todoText,
      date: DateTime.now(),
    );

    await newDoc.set(todo.toMap());
    _todoController.clear();
  }

  void _deleteToDoItem(String id) async {
    await _todoRef.doc(id).delete();
  }

  void _handleToDoChange(ToDo todo) async {
    await _todoRef.doc(todo.id).update({'isDone': !todo.isDone});
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      _searchKeyword = enteredKeyword;
    });
  }

  Map<String, List<ToDo>> _groupTasks(List<ToDo> todos) {
    Map<String, List<ToDo>> grouped = {};
    for (var todo in todos) {
      final dateKey =
          "${todo.date.day.toString().padLeft(2, '0')}/${todo.date.month.toString().padLeft(2, '0')}/${todo.date.year}";
      if (!grouped.containsKey(dateKey)) grouped[dateKey] = [];
      grouped[dateKey]!.add(todo);
    }
    return grouped;
  }

  List<ToDo> _filterTasks(List<ToDo> todos) {
    if (_searchKeyword.isEmpty) return todos;

    return todos.where((todo) {
      final textMatch =
          (todo.todoText).toLowerCase().contains(_searchKeyword.toLowerCase());

      final formattedDate =
          "${todo.date.day.toString().padLeft(2, '0')}/${todo.date.month.toString().padLeft(2, '0')}/${todo.date.year}";

      final dateMatch = formattedDate.contains(_searchKeyword);

      return textMatch || dateMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 231, 236),
      appBar: AppBar(
        title: const Text('Todo App'),
        backgroundColor: const Color.fromARGB(255, 215, 197, 35),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(1),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _todoRef.orderBy('date', descending: true).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      List<ToDo> todos = snapshot.data!.docs
                          .map((doc) =>
                              ToDo.fromMap(doc.data() as Map<String, dynamic>, doc.id))
                          .toList();

                      final filteredTodos = _filterTasks(todos);
                      final groupedTasks = _groupTasks(filteredTodos);

                      return ListView(
                        children: groupedTasks.entries.map((entry) {
                          String date = entry.key;
                          List<ToDo> tasks = entry.value;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Date header
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  date,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              // Tasks under this date
                              for (ToDo todo in tasks.reversed)
                                MyList(
                                  todo: todo,
                                  onToDoChanged: _handleToDoChange,
                                  onDeleteItem: _deleteToDoItem,
                                ),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Add Task Input
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _todoController,
                      decoration: const InputDecoration(
                        hintText: 'Add a new task',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20, bottom: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      _addToDoItem(_todoController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      minimumSize: const Size(60, 60),
                      elevation: 10,
                    ),
                    child: const Text('+', style: TextStyle(fontSize: 30)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  color: Color.fromARGB(255, 181, 169, 169),
                  size: 20,
                ),
                prefixIconConstraints:
                    BoxConstraints(minWidth: 40, minHeight: 40),
                hintText: 'Search by task or date (dd/MM/yyyy)',
                hintStyle:
                    TextStyle(color: Color.fromARGB(255, 181, 169, 169)),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.black54),
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );

              if (pickedDate != null) {
                final formattedDate =
                    "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
                _runFilter(formattedDate);
              }
            },
          ),
        ],
      ),
    );
  }
}


