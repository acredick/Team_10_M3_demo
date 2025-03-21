import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavBar({Key? key, required this.currentIndex, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: const Color(0xFFDCB347),
      indicatorColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            // When selected, text color changes to purple
            return const TextStyle(
              color: Color(0xFF5B3184), // Purple when selected
              fontSize: 12,
              fontWeight: FontWeight.bold,
            );
          }
          // Default white text when not selected
          return const TextStyle(
            color: Colors.white, 
            fontSize: 12,
            fontWeight: FontWeight.bold,
          );
        },
      ),
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      // Navbar icons + texts
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home, color: currentIndex == 0 ? const Color(0xFF5B3184) : Colors.white),
          label: 'home',
        ),
        NavigationDestination(
          icon: Icon(Icons.list, color: currentIndex == 1 ? const Color(0xFF5B3184) : Colors.white),
          label: 'orders',
        ),
        NavigationDestination(
          icon: Icon(Icons.person, color: currentIndex == 2 ? const Color(0xFF5B3184) : Colors.white),
          label: 'profile',
        ),
      ],
    );
  }
}

