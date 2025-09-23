

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_etb/login/login_page.dart';
import 'package:project_etb/pages/bmi.dart';
import 'package:project_etb/pages/expensetracker.dart';
import 'package:project_etb/pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_etb/models/todo.dart';
import 'package:project_etb/pages/todolist.dart';
import 'package:project_etb/models/expense.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  final User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference _todoRef = FirebaseFirestore.instance.collection('todos');
  final CollectionReference _expenseRef = FirebaseFirestore.instance.collection('expenses');

  final List<Widget> _pages = const [
    Center(child: Text("Home Page Content")),
    Todolist(),
    ExpenseTracker(),
    BMICalculatorPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Convert Map to ToDo model
  ToDo todoFromMap(Map<String, dynamic> map) {
    DateTime date;
    if (map['date'] is Timestamp) {
      date = (map['date'] as Timestamp).toDate();
    } else if (map['date'] is DateTime) {
      date = map['date'] as DateTime;
    } else {
      date = DateTime.now();
    }

    return ToDo(
      id: map['id'],
      todoText: map['todoText'],
      isDone: map['isDone'] ?? false,
      date: date,
    );
  }

  // Convert Map to Expense model
  Expense expenseFromMap(Map<String, dynamic> map) {
    DateTime date;
    if (map['date'] is Timestamp) {
      date = (map['date'] as Timestamp).toDate();
    } else if (map['date'] is DateTime) {
      date = map['date'] as DateTime;
    } else {
      date = DateTime.now();
    }

    return Expense(
      id: map['id'],
      title: map['title'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      description: map['description'] ?? '',
      date: date,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 231, 236),
      appBar: _selectedIndex == 0
          ? AppBar(
              backgroundColor: const Color.fromARGB(255, 215, 197, 35),
              title: user == null
                  ? const Text("Welcome, User", style: TextStyle(fontSize: 20, color: Colors.black))
                  : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance.collection("users").doc(user!.uid).snapshots(),
                      builder: (context, snapshot) {
                        String displayName = "User";
                        if (snapshot.hasData && snapshot.data!.data() != null) {
                          final userData = snapshot.data!.data();
                          displayName = userData?["name"] ??
                              FirebaseAuth.instance.currentUser?.displayName ??
                              FirebaseAuth.instance.currentUser?.email ??
                              "User";
                        } else {
                          displayName = FirebaseAuth.instance.currentUser?.displayName ??
                              FirebaseAuth.instance.currentUser?.email ??
                              "User";
                        }
                        return Row(
                          children: [
                            const Text("Welcome, ", style: TextStyle(fontSize: 20)),
                            Text(displayName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        );
                      },
                    ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: PopupMenuButton<String>(
                    offset: const Offset(0, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onSelected: (value) async {
                      if (value == "profile") {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                      } else if (value == "logout") {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushAndRemoveUntil(
                            context, MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: "profile",
                        child: Row(
                          children: [Icon(Icons.person, color: Colors.black54), SizedBox(width: 8), Text("Profile")],
                        ),
                      ),
                      const PopupMenuItem(
                        value: "logout",
                        child: Row(
                          children: [Icon(Icons.logout, color: Colors.black54), SizedBox(width: 8), Text("Logout")],
                        ),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(color: const Color.fromARGB(255, 198, 197, 187), shape: BoxShape.circle),
                      child: const CircleAvatar(backgroundImage: AssetImage('image/asd.jpg'), radius: 18),
                    ),
                  ),
                ),
              ],
            )
          : null,
     

      // Inside the body of Homepage (_selectedIndex == 0)
body: _selectedIndex == 0
    ? SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 ToDo List Today
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.yellow[200], borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "ToDo List - Today",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, ),
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder<QuerySnapshot>(
                    stream: _todoRef
                        .where('date',
                            isGreaterThanOrEqualTo: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))
                        .where('date',
                            isLessThan: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1))
                        .orderBy('date', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                      final todos = snapshot.data!.docs.map((doc) {
                        final map = doc.data() as Map<String, dynamic>;
                        map['id'] = doc.id;
                        return todoFromMap(map);
                      }).toList();

                      if (todos.isEmpty) return const Center(child: Text("No tasks for today"));

                      return Table(
                        border: TableBorder(horizontalInside: BorderSide(color: Colors.grey.shade400, width: 1)),
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        columnWidths: const {
                          0: FlexColumnWidth(4),
                          1: FlexColumnWidth(2),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(color: Colors.yellow.shade300),
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                child: Text("Task", style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          ...todos.map((todo) {
                            return TableRow(children: [
                              Padding(padding: const EdgeInsets.all(8.0), child: Text(todo.todoText)),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Checkbox(
                                    value: todo.isDone,
                                    onChanged: (val) {
                                      _todoRef.doc(todo.id).update({'isDone': !todo.isDone});
                                    },
                                  )),
                            ]);
                          }).toList(),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

         

            // 🔹 Expenses Today
Container(
  
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
      color: Colors.orange[200], borderRadius: BorderRadius.circular(12)),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Expenses - Today",
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            //decoration: TextDecoration.underline
            ),
      ),
      const SizedBox(height: 10),
      StreamBuilder<QuerySnapshot>(
        stream: _expenseRef
            .where('date',
                isGreaterThanOrEqualTo: DateTime(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day))
            .where('date',
                isLessThan: DateTime(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day + 1))
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final expenses = snapshot.data!.docs.map((doc) {
            final map = doc.data() as Map<String, dynamic>;
            map['id'] = doc.id;
            return expenseFromMap(map);
          }).toList();

          if (expenses.isEmpty)
            return const Center(child: Text("No expenses for today"));

          final dailyTotal =
              expenses.fold<double>(0, (sum, item) => sum + item.amount);

          return SingleChildScrollView(
            scrollDirection: Axis.vertical, // Enable horizontal scroll
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: IntrinsicColumnWidth(), // Title adjusts to content
                1: FlexColumnWidth(5), // Description adjusts to content
                2: FixedColumnWidth(80), // Amount column fixed width
              },
              border: TableBorder(
                horizontalInside: BorderSide(
                  color: Colors.grey.shade400,
                  width: 1,
                ),
              ),
              children: [
                // Header
                TableRow(
                  decoration: BoxDecoration(color: Colors.orange.shade300),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Title",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Description",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Amount",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                // Expense rows
                ...expenses.map((exp) {
                  return TableRow(children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(exp.title)),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(exp.description ?? '')),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("\Rs.${exp.amount.toStringAsFixed(0)}",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold))),
                  ]);
                }).toList(),
                // Daily total
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade200),
                  children: [
                    const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Total",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.blue))),
                    const SizedBox(),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("\Rs.${dailyTotal.toStringAsFixed(0)}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.blue))),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    ],
  ),
),
          ],
        ),
      )
    : _pages[_selectedIndex],






      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 215, 197, 35),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(255, 163, 119, 119),
        unselectedItemColor: const Color.fromARGB(255, 237, 235, 235),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'To-Do'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Expense Tracker'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'BMI Calculator'),
        ],
      ),
    );
  }
}

