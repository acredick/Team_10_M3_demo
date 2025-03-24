import 'package:flutter/material.dart';

class DropoffConfirmation extends StatelessWidget {
  const DropoffConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm Dropoff"),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: const Center(
        child: Text(
          "🚧 This page is not implemented yet.",
          style: TextStyle(fontSize: 18),
        ),
      )
    );
  }
  
}