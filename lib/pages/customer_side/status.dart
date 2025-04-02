import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/pages/customer_side/order_manager.dart';

class Status extends StatefulWidget {
  final String? orderID;

  Status({required this.orderID});

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  late Stream<DocumentSnapshot> _orderStream;

  @override
  void initState() {
    super.initState();
    _orderStream =
        FirebaseFirestore.instance
            .collection('orders')
            .doc(widget.orderID)
            .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Status"),
        automaticallyImplyLeading: false, // prevents back button
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _orderStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error loading order status"));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("Error loading order status"));
          }

          var order = snapshot.data!;
          String? orderID = OrderManager().getOrderID();

          // Case when no order is selected
          if (orderID == "-1") {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Please select an order to deliver.",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          String status = order['status'] ?? 'Unknown';
          String address = order['address'] ?? 'Unknown';
          double price = order['price'] ?? 0.0;
          String restaurantName = order['restaurantName'] ?? 'Unknown';

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Order Status: $status', style: TextStyle(fontSize: 20)),
                SizedBox(height: 20),
                Text(
                  'Restaurant: $restaurantName',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                Text('Address: $address', style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),
                Text(
                  'Total Price: \$${price.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18),
                ),

                if (status == 'Placed') ...[
                  Text("Your order is being processed."),
                ] else if (status == 'Processing') ...[
                  Text("Your order is being prepared."),
                ] else if (status == 'Delivery') ...[
                  Text("Your order is on the way!"),
                ] else if (status == 'Delivered') ...[
                  Text("Your order has been delivered!"),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
