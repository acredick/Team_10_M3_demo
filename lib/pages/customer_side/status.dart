import 'package:DormDash/pages/shared/order_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/widgets/customer_page.dart';
import '/pages/customer_side/customer_chat.dart';
import 'package:DormDash/widgets/bottom-nav-bar.dart';
import '/pages/shared/chat_manager.dart';
import '/pages/customer_side/rate_deliverer.dart';

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

  // Helper function to map Firestore status to string
  String _getOrderStatus(dynamic status) {
    // Check if status is a String or int, and convert to int if necessary
    int statusInt = (status is String) ? int.tryParse(status) ?? -1 : status;

    switch (statusInt) {
      case 0:
        return 'Placed';
      case 1:
        return 'Waiting for pickup';
      case 2:
        return 'Out for delivery';
      case 3:
        return 'Delivered';
      case 4:
        return 'Complete';
      default:
        return 'Unknown Status';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Status",
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false, // prevents back button
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.help_outline, color: Colors.black),
          )
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: orderStream,
        builder: (context, snapshot)  {
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
          String address = order['address'] ?? 'Unknown';
          double price = order['price'] ?? 0.0;
          String restaurantName = order['restaurantName'] ?? 'Unknown';
          String customerName = order['customerFirstName'] ?? 'Jeff'; // Use dynamic customer name
          String dasher = order['delivererFirstName'] == ""
              ? "Waiting on a dasher..."
              : "${order['delivererFirstName']}";
          // int itemCount = order['itemCount'] ?? 2; // Use dynamic item count

          String orderStatus = _getOrderStatus(order['status']);
          int statusInt = (order['status'] is String) ? int.tryParse(order['status']) ?? -1 : order['status'];

          if (statusInt == 3 || orderStatus == 'Delivered') {
            // Navigate to another page when the order is delivered
            Future.delayed(Duration.zero, () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    body: RateDeliverer(),
                    bottomNavigationBar: CustomBottomNavigationBar(
                      selectedIndex: 0,
                      onItemTapped: (index) {},
                      userType: "customer",
                    ),
                  ),
                ),
              );
            });
          }

          return Column(
            children: [
              SizedBox(
                height: 380,
                width: double.infinity,
                child: Image.asset('assets/map_placeholder.png', fit: BoxFit.cover),
              ),
              Expanded(
                child: DeliveryDetailsCard(
                  customerName: dasher,
                  typeLabel: "Your dasher",
                  address: address,
                  onCallTap: () {},  // TODO: add later
                  onDirectionsTap: () {},
                  onChatTap: () {
                    if (dasher == "Waiting on a dasher...") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Chat not available yet."),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            body: CustomerChatScreen(chatID: ChatManager.getRecentChatID()),
                            bottomNavigationBar: CustomBottomNavigationBar(
                              selectedIndex: 0,
                              onItemTapped: (index) {},
                              userType: "customer",
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  title: restaurantName,
                  status: orderStatus,
                  price: price, itemCount: 1, // TODO: add later
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
