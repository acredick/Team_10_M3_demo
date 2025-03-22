/* Status page where customers are redirected to after they have selected an order to be delivered. */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/widgets/bottom-nav-bar.dart';
import '/pages/customer_side/customer_chat.dart';

class Status extends StatefulWidget {
  const Status({Key? key}) : super(key: key);

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  Map userData = {};
  bool isAccepted =
      false; // represents whether or not a dasher has accepted order

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            isAccepted
                ? ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          body: ChatScreen(),
                          bottomNavigationBar: CustomBottomNavigationBar(
                            selectedIndex: 0,
                            onItemTapped: (index) {
                            },
                            userType: "customer",
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Press to simulate chatting with a DormDasher",
                  ),
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Waiting on a DormDasher to accept..."),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isAccepted = true;
                        });
                      },
                      child: const Text(
                        "Press to simulate a DormDasher accepting order",
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
