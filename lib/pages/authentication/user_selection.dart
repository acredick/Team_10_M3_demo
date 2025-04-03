/* Where a user selects "customer" or "deliverer" status */

import 'package:DormDash/pages/deliverer_side/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../customer_side/order_selection.dart';
import './login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/widgets/bottom-nav-bar.dart';
import '../shared/user_util.dart';

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
          Text("Hello ${UserUtils.getFullName()}!"),
          Text("Are you here as a customer or a deliverer?"),
          Center(
            child: ElevatedButton.icon(
              onPressed: () async {
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
                Navigator.pushNamed(context, '/dashboard');
              },
              label: const Text("Deliverer"),
            ),
          ),
        ],
      ),
    );
  }
}
