import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/pages/customer_side/order_manager.dart';
import 'package:uuid/uuid.dart';

class EnterAddressPage extends StatefulWidget {
  final String orderID;

  EnterAddressPage({required this.orderID});

  @override
  _EnterAddressPageState createState() => _EnterAddressPageState();
}

class _EnterAddressPageState extends State<EnterAddressPage> {
  final TextEditingController _addressController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _submitAddress() async {
    // create unique order ID
    var uuid = Uuid();
    String orderID = uuid.v4();

    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Address cannot be empty")));
      return;
    }

    await _firestore.collection('orders').doc(widget.orderID).update({
      "address": _addressController.text,
      "status": "Processing",
      "orderID": orderID,
    });

    OrderManager.setOrderID(orderID);
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
              onPressed: () async {
                await _submitAddress();
                if (mounted) Navigator.pushNamed(context, "/customer-home"); // Go back after submission
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
