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
      child: const Center(child: UserSelection()),
    );
  }
}

const Color primaryPurple = Color(0xFF5B3184);

class UserSelection extends StatefulWidget {
  const UserSelection({super.key, this.user});
  final User? user;

  @override
  State<UserSelection> createState() => _UserSelectionState();
}

class _UserSelectionState extends State<UserSelection> {
  String fullName = "";

  @override
  void initState() {
    super.initState();
    _loadUserFullName();
  }

  Future<void> _loadUserFullName() async {
    final name = await UserUtils.getFullName();
    setState(() {
      fullName = name ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const Text(
                  "Welcome,",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Are you here as a customer or a deliverer?",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPurple,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                UserUtils.setUserType("customer");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
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
              label: const Text(
                "Customer",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.delivery_dining, color: primaryPurple),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: primaryPurple, width: 2),
                ),
              ),
              onPressed: () async {
                UserUtils.setUserType("deliverer");
                Navigator.pushNamed(context, '/dashboard');
              },
              label: const Text(
                "Deliverer",
                style: TextStyle(color: primaryPurple, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
