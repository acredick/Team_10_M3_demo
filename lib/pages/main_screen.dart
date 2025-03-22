// This page controls navigation between pages.

import 'package:flutter/material.dart';
import '../../components/navbar.dart'; 
//import 'dashboard.dart'; // Home Page
//import 'orders_page.dart'; // Orders Page
//import 'profile_page.dart'; // Profile Page

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // Track which page is selected

  final List<Widget> _pages = [
    
    /* TODO: make and implement pages
    DashboardPage(), // Home Page
    OrdersPage(),    // Orders Page
    ProfilePage(),   // Profile Page */
  ];

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Dynamically switch between pages
      bottomNavigationBar: NavBar( 
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
