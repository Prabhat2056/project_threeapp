


//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:project_etb/login/first_page.dart';
//import 'package:project_etb/login/login_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text("🏠 Home Page", style: TextStyle(fontSize: 20))),
    Center(child: Text("📄 Todo List Page", style: TextStyle(fontSize: 20))),
    Center(child: Text("Expense Tracker", style: TextStyle(fontSize: 20))),
    Center(child: Text("BMI Calculator Page", style: TextStyle(fontSize: 20))),
  ]; // We will add your pages here

  @override
  void initState() {
    super.initState();

    // Add the first page (your hero + welcome text + logout button)
    // _pages.add(_buildWelcomePage());

    // // Add other placeholder pages for bottom nav items
    // _pages.add(const Center(child: Text("Expense Page")));
    // _pages.add(const Center(child: Text("To-Do Page")));
    // _pages.add(const Center(child: Text("BMI Calculator Page")));
    
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Widget _buildWelcomePage() {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Hero(
  //           tag: 'first-hero',
  //           child: Image.asset(
  //             "image/first.png",
  //             height: 150, // Hero animation image
  //           ),
  //         ),
  //         const SizedBox(height: 20),
  //         const Text(
  //           "Welcome to the Home Page!",
  //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //         ),
  //         const SizedBox(height: 10),
  //         const Text(
  //           "You are now logged in.",
  //           style: TextStyle(fontSize: 16, color: Colors.grey),
  //         ),
  //         const SizedBox(height: 30),

  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(builder: (context) => const FirstPage()),
  //             );
  //           },
  //           style: ElevatedButton.styleFrom(
  //             padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(30),
  //             ),
  //           ),
  //           child: const Text("LOGOUT", style: TextStyle(fontSize: 16)),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 231, 236),
      //drawer: const MenuPage(), // when clicked on menu icon, it will open the drawer
      appBar: AppBar(
        title: const Text('Todo App'),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
          actions: [
          //Padding(
            // padding: const EdgeInsets.only(right: 12.0),
            // child: GestureDetector(
            //   onTap: () {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(content: Text('Profile clicked')),
            //     );

            //     // Navigate to ProfilePage when the avatar is tapped
            //     // Navigator.push(
            //     //   context,
            //     //   MaterialPageRoute(builder: (context) => const ProfilePage()),
            //     // );
                
            //   },
              // child: const CircleAvatar(
              //   backgroundImage: AssetImage(
              //     'image/asd.jpg',
              //   ), // 👈 Your image path
              //   radius: 18,
              // ),

              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: PopupMenuButton<String>(
                  offset: const Offset(0, 50), // dropdown position
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) {
                    if (value == "profile") {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const ProfilePage()),
                    // );
                    } else if (value == "logout") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Logged out")),
                      );
                      // TODO: add your logout logic here
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
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('image/asd.jpg'),
                      radius: 18,
                    ),
                ),
              ),
            ],  
          ),
        
        
      
      body: _pages[_selectedIndex],

      

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.teal.shade800,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade400,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          //BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Expense'),
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'To-Do'),
           BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Expense Tracker'),
          // BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ToDo List'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'BMI Calculator'),
          
        ],
      ),
    );
  }
}
