import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'customer_address.dart';
import '../shared/order_manager.dart';

class OrderSelection extends StatefulWidget {
  @override
  _OrderSelectionState createState() => _OrderSelectionState();
}

class _OrderSelectionState extends State<OrderSelection> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Selection"),
        automaticallyImplyLeading: false, // prevents back button
      ),
      body: Builder(
        builder: (context) {
          String? orderID = OrderManager.getOrderID();

          // If the user has an existing order out for delivery (orderID is not -1)
          if (orderID != "-1") {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Order in Progress"),
                    content: Text(
                      "You already have one order out for delivery. Please wait to select another order.",
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text("Okay"),
                        onPressed: () {
                          Navigator.pushNamed(context, "/customer-home");
                        },
                      ),
                    ],
                  );
                },
              );
            });

            return Center(
              child: CircularProgressIndicator(), // Show a loading indicator until dialog is closed
            );
          }

          return StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('orders').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              var orders = snapshot.data!.docs;

              if (orders.isEmpty) {
                return Center(
                  child: Text(
                    "No orders available!",
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }

              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  var order = orders[index];
                  bool isDeliverable = order["isDeliverable"] == true;

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: isDeliverable ? null : Colors.grey[300],
                    child: ListTile(
                      contentPadding: EdgeInsets.all(15),
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
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order["restaurantName"],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "\$${order["price"]}",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 2),
                          Text(
                            order["Items"].join(", "),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      trailing: Icon(
                        Icons.arrow_forward,
                        color: isDeliverable ? Colors.purple[700] : Colors.grey,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

}
