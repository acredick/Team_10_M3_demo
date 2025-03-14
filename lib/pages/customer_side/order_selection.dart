/* Where a customer picks what order they want to be delivered. */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './order_storage.dart';
import 'package:intl/intl.dart';
import './status.dart';

class OrderSelection extends StatefulWidget {
  @override
  _OrderSelectionState createState() => _OrderSelectionState();
}

class _OrderSelectionState extends State<OrderSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order Selection")),
      body: orderStorage.orders.isEmpty
          ? Center(child: Text("No orders yet!", style: TextStyle(fontSize: 20)))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Select an order for delivery.",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            ListView.builder(
              shrinkWrap: true, // Ensures it takes only needed space
              physics: NeverScrollableScrollPhysics(), // Prevents double scrolling
              itemCount: orderStorage.orders.length,
              itemBuilder: (context, index) {
                final order = orderStorage.orders[index];
                bool isDeliverable = order["isDeliverable"] == "true";
                return Card(
                  margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  color: isDeliverable ? null : Colors.grey,
                  child: ListTile(
                    onTap: () {
                      if (isDeliverable == false) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("This order is no longer eligible for delivery."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: Text("Back"),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirm Selection"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min, // Prevents unnecessary space
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Are you sure you want to select this order?"),
                                  SizedBox(height: 10),
                                  Text(
                                    order["restaurant"]!,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text("${order["foodItems"]}"),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Perform action on confirmation
                                    print("Order selected");
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Status()),
                                    );
                                  },
                                  child: Text("Confirm"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust spacing
                      children: [
                        Text(
                          order["restaurant"]!,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          order["orderTime"]!,
                          style: TextStyle(
                            fontSize: 16,
                            color: order["isDeliverable"] == "true" ? Colors.grey : Colors.grey[700],),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${NumberFormat.currency(locale: 'en_US', symbol: '\$').format(double.tryParse(order["price"] ?? "0") ?? 0)} • ${order["foodItems"]?.split(" • ").length ?? 0} Items",
                          style: TextStyle(fontSize: 16),
                        ),

                        Text("${order["foodItems"]}"),

                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        )
      )
    );
  }
}

