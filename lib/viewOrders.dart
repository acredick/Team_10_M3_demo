import 'package:flutter/material.dart';
import 'orders.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Orders")),
      body: orderStorage.orders.isEmpty
          ? Center(child: Text("No orders yet!", style: TextStyle(fontSize: 20)))
          : ListView.builder(
              itemCount: orderStorage.orders.length,
              itemBuilder: (context, index) {
                final order = orderStorage.orders[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(order["foodItem"]!,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name: ${order["name"]}"),
                        Text("Phone: ${order["phone"]}"),
                        Text("Address: ${order["address"]}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
