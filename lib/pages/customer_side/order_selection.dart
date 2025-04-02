import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'customer_address.dart';

class OrderSelection extends StatefulWidget {
  @override
  _OrderSelectionState createState() => _OrderSelectionState();
}

class _OrderSelectionState extends State<OrderSelection> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order Selection")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return Center(child: Text("No orders available!", style: TextStyle(fontSize: 20)));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              bool isDeliverable = order["isDeliverable"] == true;

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                color: isDeliverable ? null : Colors.grey,
                child: ListTile(
                  onTap: isDeliverable
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EnterAddressPage(orderID: order.id),
                            ),
                          );
                        }
                      : null,
                  title: Text(
                    order["restaurantName"],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Items: ${order["Items"]} \nPrice: \$${order["price"]}",
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: Icon(Icons.arrow_forward, color: isDeliverable ? Colors.blue : Colors.grey),
                ),
              );
            },
          );
        },
      ),
    );
  }
}