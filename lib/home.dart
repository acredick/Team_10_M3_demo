import 'package:flutter/material.dart';
import 'menu.dart';
import 'viewOrders.dart';

class HomeScreen extends StatelessWidget {
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
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => OrderScreen()),
                );
              },
              child: Text('Go to Menu'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrdersScreen()),
                );
              },
              child: Text("View Available Orders"),
            )
          ],
        ),
      ),
    );
  }
}