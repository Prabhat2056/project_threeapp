import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_etb/login/login_page.dart';
import 'package:project_etb/pages/bmi.dart';
import 'package:project_etb/pages/expensetracker.dart';
import 'package:project_etb/pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_etb/pages/todolist.dart';
//import 'package:project_etb/login/first_page.dart';
//import 'package:project_etb/login/login_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  final User? user = FirebaseAuth.instance.currentUser;

  final List<Widget> _pages = const [
    //Homepage(),
    //ToDoList(),
    Center(child: Text("Home Page Content")),
    Todolist(),
    ExpenseTracker(),
    BMICalculatorPage(),

    // Center(child: Text("BMI Calculator Page", style: TextStyle(fontSize: 20))),
  ]; // We will add your pages here

  @override
  void initState() {
    super.initState();

    // Add the first page (your hero + welcome text + logout button)
    // _pages.add(_buildWelcomePage());
    // // Add other placeholder pages for bottom nav items
    // _pages.add(const Center(child: Text("Expense Page")));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 231, 236),
      //backgroundColor: const Color.fromARGB(255, 215, 197, 35),

      //drawer: const MenuPage(), // when clicked on menu icon, it will open the drawer

      //--------------------------------------------------------------------------------------------------------------------
      // AppBar with dynamic welcome message
      appBar: _selectedIndex == 0
          ? AppBar(
              backgroundColor: const Color.fromARGB(255, 215, 197, 35),
              //backgroundColor: Colors.white,
              centerTitle: false, // aligns left
              title: user == null
                  ? const Text(
                      "Welcome, User",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    )
                  : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(user!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        String displayName = "User";

                        if (snapshot.hasData && snapshot.data!.data() != null) {
                          final userData = snapshot.data!.data();
                          displayName =
                              userData?["name"] ??
                              FirebaseAuth.instance.currentUser?.displayName ??
                              FirebaseAuth.instance.currentUser?.email ??
                              "User";
                        } else {
                          // Fallback if Firestore document is missing
                          displayName =
                              FirebaseAuth.instance.currentUser?.displayName ??
                              FirebaseAuth.instance.currentUser?.email ??
                              "User";
                        }

                        return Row(
                          children: [
                            const Text(
                              "Welcome, ",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              displayName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                    ),

              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: PopupMenuButton<String>(
                    offset: const Offset(0, 50), // dropdown position
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),

                    onSelected: (value) async {
                      if (value == "profile") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                          ),
                        );
                      } else if (value == "logout") {
                        // Logout user from FirebaseAuth
                        await FirebaseAuth.instance.signOut();

                        // Navigate to login page and remove all previous routes
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: "profile",
                        child: Row(
                          children: [
                            Icon(Icons.person, color: Colors.black54),
                            SizedBox(width: 8),
                            Text("Profile"),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: "logout",
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.black54),
                            SizedBox(width: 8),
                            Text("Logout"),
                          ],
                        ),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.all(2), // border thickness
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255,198,197,187), // border color
                          
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        backgroundImage: AssetImage(
                          'image/asd.jpg',
                        ), // your profile image
                        radius: 18,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : null,


      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: Colors.teal.shade800,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // selectedItemColor: Colors.white,
        selectedItemColor: const Color.fromARGB(255, 215, 197, 35),

        unselectedItemColor: Colors.grey.shade400,

        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'To-Do'),
          BottomNavigationBarItem(icon: Icon(Icons.payment),label: 'Expense Tracker',),
          BottomNavigationBarItem(icon: Icon(Icons.calculate),label: 'BMI Calculator',),
        ],
      ),
    );
  }
}
