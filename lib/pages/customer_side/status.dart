import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/widgets/customer_page.dart';

class Status extends StatefulWidget {
  final String? orderID;

  Status({required this.orderID});

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  late Stream<DocumentSnapshot> orderStream;

  @override
  void initState() {
    super.initState();
    orderStream = FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderID)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Status",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.help_outline, color: Colors.black),
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: orderStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error loading order status"));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("No order found with that ID"));
          }

          var order = snapshot.data!;
          String status = order['status'] ?? 'Unknown';
          String address = order['address'] ?? 'Unknown';
          double price = order['price'] ?? 0.0;
          String restaurantName = order['restaurantName'] ?? 'Unknown';
          String customerName = order['customerID'] ?? 'Jeff'; // Use dynamic customer name
          //int itemCount = order['itemCount'] ?? 2; // Use dynamic item count

          return Column(
            children: [
              SizedBox(
                height: 380,
                width: double.infinity,
                child: Image.asset('assets/map_placeholder.png', fit: BoxFit.cover),
              ),
              Expanded(
                child: DeliveryDetailsCard(
                  customerName: customerName,
                  typeLabel: "Dropoff To",
                  address: address,
                  //itemCount: itemCount,
                  onCallTap: () {},  // TODO: add later
                  onDirectionsTap: () {}, 
                  title: restaurantName, 
                  status: status,
                   price: price, // TODO: add later
                  
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
