import 'package:flutter/material.dart';
// import 'package:rail_sahayak/Screens/contact_us_screen.dart';
import 'package:rail_sahayak/Screens/feedback_complaint_screen.dart';
import 'package:rail_sahayak/Screens/order_screen.dart';
import 'home_screen.dart'; // Make sure this is in your lib folder

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    OrderScreen(),
    FeedbackComplaintScreen(),
    // ContactUsScreen(),
  ];

  final List<String> _titles = [
    'Home',
    'Orders',
    'Complaint Feedback',
    // 'Contact Us',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(_titles[_selectedIndex]),
      //   backgroundColor: Colors.redAccent,
      // ),
      body: SafeArea(child: _screens[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Feedback',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.contact_phone),
          //   label: 'Contact Us',
          // ),
        ],
      ),
    );
  }
}
