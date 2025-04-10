import 'package:flutter/material.dart';
import 'package:DormDash/pages/shared/order_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/widgets/customer_page.dart';
import '/pages/customer_side/customer_chat.dart';
import 'package:DormDash/widgets/bottom-nav-bar.dart';
import '/pages/shared/chat_manager.dart';
import '/pages/customer_side/rate_deliverer.dart';

class Status extends StatefulWidget {
  String? orderID;

  Status({required this.orderID});

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  late Stream<DocumentSnapshot> orderStream;
  bool isDropdownVisible = false;
  int statusInt = -1; // <-- moved here from build()
  bool hasNavigatedToRating = false;

  @override
  void initState() {
    super.initState();
    orderStream = FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderID)
        .snapshots();
  }

  String _getOrderStatus(dynamic status) {
    int localStatusInt = (status is String) ? int.tryParse(status) ?? -1 : status;

    switch (localStatusInt) {
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
        automaticallyImplyLeading: false,
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
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error loading order status"));
          }

          if (!snapshot.hasData || !snapshot.data!.exists || (_getOrderStatus(snapshot.data!['status'])) == "4") {
            return Center(child: Text("Place an order to see its status."));
          }

          var order = snapshot.data!;
          String address = order['address'] ?? 'Unknown';
          int itemCount = (order['Items'] as List).length;
          List<dynamic> items = order['Items'] ?? [];

          double price = order['price'] ?? 0.0;
          String restaurantName = order['restaurantName'] ?? 'Unknown';
          String orderId = order['orderID'];
          String dasher = order['delivererFirstName'] == ""
              ? "Waiting on a dasher..."
              : "${order['delivererFirstName']}";

          int newStatusInt = (order['status'] is String) ? int.tryParse(order['status']) ?? -1 : order['status'];
          if (newStatusInt != statusInt) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  statusInt = newStatusInt;
                });
              }
            });
          }

          String orderStatus = _getOrderStatus(order['status']);

          if (statusInt == 3 && !hasNavigatedToRating) {
            hasNavigatedToRating = true; // prevent repeat navigation
            Future.delayed(Duration.zero, () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    body: RateDeliverer(orderId: orderId),
                  ),
                ),
              );
            });
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Image.asset(
                  'assets/map_placeholder.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              DeliveryDetailsCard(
                customerName: dasher,
                typeLabel: "Your dasher",
                address: address,
                onDirectionsTap: () {},
                onChatTap: () {
                  if (dasher == "Waiting on a dasher...") {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Chat Unavailable'),
                          content: Text('We are still waiting for a Dasher to accept your order. Hang tight!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
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
                price: price,
                itemCount: itemCount,
                isDropdownVisible: isDropdownVisible,
                onExpandTap: () {
                  setState(() {
                    isDropdownVisible = !isDropdownVisible;
                  });
                },
                orderItems: items,
                items: items,
              ),
            ],
          );
        },
      ),
    );
  }
}
