import 'package:flutter/material.dart';
import 'checkout.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String? selectedFood;

  void selectFood(String food) {
    setState(() {
      selectedFood = food;
    });
  }

  void proceedToCheckout() {
    if (selectedFood != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutScreen(foodItem: selectedFood!), // Pass the selected food item
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order Food")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Select a food item:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => selectFood("Hamburger"),
              child: Text("Hamburger"),
            ),
            ElevatedButton(
              onPressed: () => selectFood("Chicken Tenders"),
              child: Text("Chicken Tenders"),
            ),
            ElevatedButton(
              onPressed: () => selectFood("Pizza"),
              child: Text("Pizza"),
            ),
            SizedBox(height: 20),
            if (selectedFood != null) ...[
              Text(
                "You selected: $selectedFood",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: proceedToCheckout,
                child: Text("Proceed to Checkout"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
