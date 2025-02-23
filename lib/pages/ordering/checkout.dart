import 'package:flutter/material.dart';
import 'orders.dart';
import 'viewOrders.dart'; // Import the Orders screen

class CheckoutScreen extends StatefulWidget {
  final String foodItem;

  CheckoutScreen({required this.foodItem});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void submitOrder() {
    if (_formKey.currentState!.validate()) {
      orderStorage.addOrder(
        widget.foodItem,
        _nameController.text,
        _phoneController.text,
        _addressController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order placed successfully!")),
      );

      // Navigate to OrdersScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OrdersScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("You're ordering: ${widget.foodItem}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Full Name"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter your name" : null,
              ),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: "Phone Number"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter your phone number" : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: "Delivery Address"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter your address" : null,
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: submitOrder,
                  child: Text("Place Order"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
