/* Pages listed here will have a bottom navigation bar. */

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/pages/authentication/user_selection.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.user});
  final User? user;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String userType = ""; // Default value (should be fetched dynamically)

  @override
  void initState() {
    super.initState();
  }

  // Different navigation bars based on user type
  Widget _buildBottomNavigationBar() {
    if (userType == "deliverer") {
      return BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      );
    } else if (userType== "customer") {
      return BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      );
    }
    else {
      return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserSelection(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
