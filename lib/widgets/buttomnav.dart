import 'package:flutter/material.dart';
import 'package:project_etb/homepage.dart';


class MyBottomNavApp extends StatefulWidget {
  const MyBottomNavApp({super.key});

  @override
  State<MyBottomNavApp> createState() => _MyBottomNavAppState();
}

class _MyBottomNavAppState extends State<MyBottomNavApp> {
  int _selectedIndex = 0; //default to homepage

  final List<Widget> _pages = const [ //index 0 for homepage, index 1 for calculator page, index 2 for qr page, index 3 for chart page, index 4 for cart page
    Homepage(),                       //list the button nav pages here
    
    //CalculatorPage(),
    //QrPage(),
    //ChartPage(),
    //CartPage(),
  ];

  void _onItemTapped(int index) {  //Tap on "Calc" (index 1) → _onItemTapped(1) → _selectedIndex = 1 → CalculatorPage is shown.
  
    setState(() {
      _selectedIndex = index;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          const Color.fromARGB(255, 169, 174, 169); // Placeholder for QR scan action
          // TODO: Implement QR scan action
        },
        backgroundColor: Colors.green.shade700,
        tooltip: "Scan QR",
        child: const Icon(Icons.qr_code_scanner),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.teal.shade800,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade400,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, ), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Calc'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'QR'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Chart'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        ],
      ),
    );
  }
}
