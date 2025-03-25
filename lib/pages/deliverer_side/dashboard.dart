import 'package:firebase_auth/firebase_auth.dart';

import '/pages/authentication/user_selection.dart';
import 'package:flutter/material.dart';
import 'package:DormDash/widgets/bottom-nav-bar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, this.user});
  final User? user;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<bool> isOrderAccepted = [false, false, false]; // Track acceptance for each order
 // Track if an order has been accepted

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width * 0.98,
              height: 200,
              decoration: BoxDecoration(
                color: Color(0xFF5B3184),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "HELLO",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10.0, 0), // Adjust the padding value as needed
                          child: FittedBox(
                            fit: BoxFit.scaleDown, // Scales the text down to fit the container
                            child: Text(
                              "${UserSelection(user: widget.user).fullName().toUpperCase()}",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        Text(
                          "Earned Money",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          "\$000.000",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Map Placeholder
                  Padding(
                    padding: EdgeInsets.only(right: 30),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.3,
                        width: MediaQuery.of(context).size.width * 0.4,
                        color: Colors.white,
                        child: Image.asset(
                          'assets/images/mapimage.png', // Replace with actual Google Maps widget
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Filter Section
            Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Filter",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
      // Order List Section
            Expanded(
              child: ListView(
                children: [
                  OrderCard(
                    image: 'assets/images/food1.png',
                    pickup: 'Campus Center',
                    dropoff: 'University Library',
                    price: 5,
                    isOrderAccepted: isOrderAccepted[0],
                    onAccept: () {
                      setState(() {
            // Want to accept  order and mark others as not accepted
            for (int i = 0; i < isOrderAccepted.length; i++) {
              isOrderAccepted[i] = (i == 0); // Only one at a time? is accepted
            }
          });
        },
      ),
                  OrderCard(
                    image: 'assets/images/food2.png',
                    pickup: 'Campus Center',
                    dropoff: 'University Library',
                    price: 5,
                    isOrderAccepted: isOrderAccepted[1],
                    onAccept: () {
                      setState(() {
            
            for (int i = 0; i < isOrderAccepted.length; i++) {
              isOrderAccepted[i] = (i == 1); 
            }
          });
        },
      ),
                  OrderCard(
                    image: 'assets/images/food3.png',
                    pickup: 'Campus Center',
                    dropoff: 'University Library',
                    price: 5,
                    isOrderAccepted: isOrderAccepted[2],
                    onAccept: () {
                      setState(() {
            
            for (int i = 0; i < isOrderAccepted.length; i++) {
              isOrderAccepted[i] = (i == 2); 
            }
          });
        },
      ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 0,
        userType: "deliverer",
        onItemTapped: (index) {},
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String image;
  final String pickup;
  final String dropoff;
  final int price;
  final bool isOrderAccepted;
  final VoidCallback onAccept;

  OrderCard({
    required this.image,
    required this.pickup,
    required this.dropoff,
    required this.price,
    required this.isOrderAccepted,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12)),
              child: Image.asset(
                image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pickup Point",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Colors.black54),
                        SizedBox(width: 5),
                        Text(pickup, style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Pick-out Point",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Colors.black54),
                        SizedBox(width: 5),
                        Text(dropoff, style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Earn: \$$price",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: ElevatedButton(
                onPressed: isOrderAccepted ? null : onAccept,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFDCB347), // Gold button color
                  foregroundColor: Colors.white,
                ),
                child: Text(isOrderAccepted ? "Order Accepted" : "Accept"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
