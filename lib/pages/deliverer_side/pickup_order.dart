import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:DormDash/widgets/pickup_delivery_details_template.dart';

class OrdersPage extends StatefulWidget {
  final String orderId;

  const OrdersPage({super.key, required this.orderId});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  Map<String, dynamic>? orderData;

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  void fetchOrderDetails() async {
    DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderId)
        .get();

    if (orderSnapshot.exists) {
      setState(() {
        orderData = orderSnapshot.data() as Map<String, dynamic>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (orderData == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Loading...')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pickup by ${orderData!['pickupTime'] ?? 'Unknown'}',
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
      ),
      body: Column(
        children: [
          SizedBox(
            height: 350,
            width: double.infinity,
            child: Image.asset('assets/map_placeholder.png', fit: BoxFit.cover),
          ),
          Expanded(
            child: DeliveryDetailsCard(
              typeLabel: "Pickup From",
              title: orderData!['restaurantName'] ?? "Unknown Restaurant",
              address: orderData!['restaurantAddress'] ?? "Unknown Address",
              customerName: orderData!['customerName'] ?? "Unknown Customer",
              itemCount: orderData!['itemCount'] ?? 1,
              onCallTap: () {},  //TODO: Add call functionality
              onDirectionsTap: () {}, // TODO: Add navigation functionality
              onSlideComplete: () async {
                Navigator.pushNamed(context, "/deliver-order");
              },
            ),
          )
        ],
      ),
    );
  }
}
