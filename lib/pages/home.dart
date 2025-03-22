import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Welcome to DormDash!', 
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20), 
            ElevatedButton(
              onPressed: () {

              },
              child: Text('Go to Menu'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {

              },
              child: Text("View Available Orders"),
            )
          ],
        ),
      ),
    );
  }
}