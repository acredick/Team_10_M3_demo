import 'package:dormdash/pages/deliverer_side/deliver_order.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/pages/authentication/user_selection.dart';
import 'package:flutter/material.dart';
import 'package:dormdash/widgets/bottom_nav_bar.dart';

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
      body: SingleChildScrollView( // Allow scrolling
        child: Padding(
          padding: EdgeInsets.only(top: 90, left: 7, right: 7), // Container padding
          child: Column(
            children: [
              // Header Section
              Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width * 0.95, // Adjusted width
                height: 295, // Height of the purple container
                decoration: BoxDecoration(
                  color: Color(0xFF5B3184),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 40),
                          Text(
                            "HELLO",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24, // Font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
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
                          SizedBox(height: 60), // Space between elements
                          Text(
                            "Earned Money",
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Text(
                            "\$000.000",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18, // Font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Map Placeholder
                    Padding(
                      padding: EdgeInsets.only(top: 25, right: 10), // Padding for the map
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.25, // Adjusted height
                          width: MediaQuery.of(context).size.width * 0.35, // Adjusted width
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
            
              Container(
                margin: EdgeInsets.only(top: 8, bottom: 0), // No padding, just margin
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Filter",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Font size
                  ),
                ),
              ),

              // Order List Section
              SizedBox(
                height: 300, // Adjust height as needed
                child: ListView(// Allow scrolling for the ListView
                children: [
                  OrderCard(
                    image: 'assets/images/food1.png',
                    pickup: 'Campus Center',
                    dropoff: 'University Library',
                    price: 5,
                  ),
                  OrderCard(
                    image: 'assets/images/food2.png',
                    pickup: 'Campus Center',
                    dropoff: 'University Library',
                    price: 5,
                  ),
                  OrderCard(
                    image: 'assets/images/food3.png',
                    pickup: 'Campus Center',
                    dropoff: 'University Library',
                    price: 5,
                  ),
                ],
              ),
              ),
            ],
          ),
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

  const OrderCard({super.key, 
    required this.image,
    required this.pickup,
    required this.dropoff,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Padding for the order card
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
                width: 80, // Width of the image
                height: 80, // Height of the image
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8), // Padding for the content
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pickup Point",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12), // Font size
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Colors.black54),
                        SizedBox(width: 5),
                        Text(pickup, style: TextStyle(fontSize: 12)), // Font size
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Drop-off Point",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12), // Font size
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Colors.black54),
                        SizedBox(width: 5),
                        Text(dropoff, style: TextStyle(fontSize: 12)), // Font size
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Earn: \$$price",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12), // Font size
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 8), // Padding for the button
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Confirm"),
                        content: Text("Do you confirm that you want to pick up this order?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeliverOrder(), 
                                ),
                              );
                            },
                            child: Text("Accept"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text("Decline"),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFDCB347), // Gold button color
                  foregroundColor: Colors.white,
                ),
                child: Text("Accept"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
