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
          Navigator.pushReplacementNamed(context, "/orders");
          break;
        case 2:
          Navigator.pushReplacementNamed(context, "/deliverer-chat-page");
          break;
        case 3:
          Navigator.pushReplacementNamed(context, "/deliverer-settings");
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
          Navigator.pushReplacementNamed(context, "/customer-chat-page");
          break;
        case 3:
          Navigator.pushReplacementNamed(context, "/customer-settings");
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final purple = const Color(0xFF5B3184);
    final gold = const Color(0xFFDCB347);

    // Dynamically adjust the items list based on userType
    List<BottomNavigationBarItem> items = [];

    if (userType == "deliverer") {
      items = [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.list,
            color: selectedIndex == 0 ? purple : Colors.white,
          ),
          label: "Orders",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.dashboard,
            color: selectedIndex == 1 ? purple : Colors.white,
          ),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.message,
            color: selectedIndex == 2 ? purple : Colors.white,
          ),
          label: "Messages",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
            color: selectedIndex == 3 ? purple : Colors.white,
          ),
          label: "Settings",
        ),
      ];
    } else if (userType == "customer") {
      items = [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: selectedIndex == 0 ? purple : Colors.white,
          ),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.list,
            color: selectedIndex == 1 ? purple : Colors.white,
          ),
          label: "Orders",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.message,
            color: selectedIndex == 2 ? purple : Colors.white,
          ),
          label: "Messages",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
            color: selectedIndex == 3 ? purple : Colors.white,
          ),
          label: "Settings",
        ),
      ];
    } else {
      return const SizedBox.shrink(); // Return an empty widget if userType is invalid
    }

    return BottomNavigationBar(
      backgroundColor: gold,
      currentIndex: selectedIndex,
      onTap: (index) {
        onItemTapped(index); // Update selected index when an item is tapped
        _onItemTapped(context, index); // Navigate to the appropriate page
      },
      selectedItemColor: purple,
      unselectedItemColor: Colors.white,
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Color(0xFF5B3184),
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      type: BottomNavigationBarType.fixed,
      items: items,
    );
  }
}
