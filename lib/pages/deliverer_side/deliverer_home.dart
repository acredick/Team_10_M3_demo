/* Home page for deliverers. */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DelivererHome extends StatefulWidget {
  const DelivererHome({Key? key}) : super(key: key);

  @override
  State<DelivererHome> createState() => _DelivererHomeState();
}

class _DelivererHomeState extends State<DelivererHome> {
  Map userData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Text("Welcome to the deliverer home page.")
              ),
            ]
        )
    );
  }
}

