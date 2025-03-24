/* Where a user selects "customer" or "deliverer" status */

import 'package:DormDash/pages/deliverer_side/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../customer_side/order_selection.dart';
import '../customer_side/order_storage.dart';
import '../deliverer_side/deliverer_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/widgets/bottom-nav-bar.dart';

class UserSelectionRoute extends StatelessWidget {
  const UserSelectionRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('UserSelection'),
      ),
      child: Center(child: UserSelection()),
    );
  }
}

class UserSelection extends StatefulWidget {
  const UserSelection({super.key, this.user});
  final User? user;

  String fullName() {
    String displayName = user?.displayName ?? '';
    List<String> parts = displayName.split(", ");
    if (parts.length < 2)
      return displayName; // Return original if format is incorrect

    String lastName = parts[0];
    String firstAndMiddle = parts[1];

    return "$firstAndMiddle $lastName";
  }

  @override
  State<UserSelection> createState() => _UserSelectionState();
}

class _UserSelectionState extends State<UserSelection> {
  Map userData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Hello ${widget.fullName()}!"),
          Text("Are you here as a customer or a deliverer?"),
          Center(
            child: ElevatedButton.icon(
              onPressed: () async {
                if (orderStorage.orders.isEmpty) {
                  fillOrderStorage();
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => Scaffold(
                          body: OrderSelection(),
                          bottomNavigationBar: CustomBottomNavigationBar(
                            selectedIndex: 0,
                            onItemTapped: (index) {},
                            userType: "customer",
                          ),
                        ),
                  ),
                );
              },
              label: const Text("Customer"),
            ),
          ),
          Center(
            child: ElevatedButton.icon(
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => Scaffold(
                      body: DashboardPage(user: widget.user),
                    ),
                  ),
                );
              },
              label: const Text("Deliverer"),
            ),
          ),
        ],
      ),
    );
  }
}
