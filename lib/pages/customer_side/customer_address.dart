import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../shared/order_manager.dart';
import 'package:uuid/uuid.dart';
import '../shared/user_util.dart';
import '/pages/shared/chat_manager.dart';

class EnterAddressPage extends StatefulWidget {
  final String orderID;


  EnterAddressPage({required this.orderID});

  @override
  _EnterAddressPageState createState() => _EnterAddressPageState();
}

class _EnterAddressPageState extends State<EnterAddressPage> {
  final TextEditingController _addressController = TextEditingController();
  static final Uuid _uuid = Uuid();
  String orderID = _uuid.v4();  // Generate a random order ID

  Future<void> _submitAddress() async {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Address cannot be empty")));
      return;
    }

    OrderManager.clearDelivererInfo(widget.orderID); // used for testing purposes
    OrderManager.updateOrder(widget.orderID, "orderID", widget.orderID);
    OrderManager.updateOrder(widget.orderID, "address", _addressController.text);
    OrderManager.updateOrder(widget.orderID, "status", "Processing");
    OrderManager.updateOrder(widget.orderID, "customerID", UserUtils.getEmail());
    OrderManager.updateOrder(widget.orderID, "customerFirstName", UserUtils.getFirstName());
    OrderManager.updateOrder(widget.orderID, "customerLastName", UserUtils.getLastName());
    OrderManager.setOrderID(widget.orderID);

    ChatManager.generateChatID();
    ChatManager.openChat();
    OrderManager.updateOrder(widget.orderID, "chatID", ChatManager.getRecentChatID());

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
