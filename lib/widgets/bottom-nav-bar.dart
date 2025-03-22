
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final String userType;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.userType,
  }) : super(key: key);

  // Define nav-bar navigation. Routes are set up in main.dart
  void _onItemTapped(BuildContext context, int index) {
    if (userType == "deliverer") {
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, "/dashboard");
          break;
        case 1:
          Navigator.pushReplacementNamed(context, "/settings");
          break;
      }
    } else if (userType == "customer") {
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, "/customer-home");
          break;
        case 1:
          Navigator.pushReplacementNamed(context, "/customer-order");
          break;
        case 2:
          Navigator.pushReplacementNamed(context, "/customer-settings");
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userType == "deliverer") {
      return BottomNavigationBar(
        backgroundColor: Color(0xFFDCB347),
        currentIndex: selectedIndex,
        onTap: (index) => _onItemTapped(context, index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      );
    } else if (userType == "customer") {
      return BottomNavigationBar(
        backgroundColor: Color(0xFFDCB347),
        currentIndex: selectedIndex,
        onTap: (index) => _onItemTapped(context, index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
