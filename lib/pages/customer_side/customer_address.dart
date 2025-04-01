import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EnterAddressPage extends StatefulWidget {
  final String orderID;

  EnterAddressPage({required this.orderID});

  @override
  _EnterAddressPageState createState() => _EnterAddressPageState();
}

class _EnterAddressPageState extends State<EnterAddressPage> {
  final TextEditingController _addressController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _submitAddress() async {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Address cannot be empty")));
      return;
    }

    await _firestore.collection('orders').doc(widget.orderID).update({
      "address": _addressController.text,
      "status": "Processing",
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order updated for delivery!")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter Delivery Address")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: "Enter your address"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitAddress,
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
