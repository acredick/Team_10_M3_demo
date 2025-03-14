/* Status page where customers are redirected to after they have selected an order to be delivered. */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Status extends StatefulWidget {
  const Status({Key? key}) : super(key: key);

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  Map userData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text("Waiting on a DormDasher to accept...")
              ),
            ]
        )
    );
  }
}

