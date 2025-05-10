import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/pages/authentication/user_selection.dart';
import '/widgets/bottom-nav-bar.dart';
import 'user_util.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserSelection(user: widget.user),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        userType: UserUtils.userType,
      ),
    );
  }
}



