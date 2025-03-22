import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            Text(
              "STUDENT NAME",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 25,
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
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFDCB347), // Matching button color
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String image;
  final String pickup;
  final String dropoff;
  final int price;

  OrderCard({
    required this.image,
    required this.pickup,
    required this.dropoff,
    required this.price,
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: ElevatedButton(
                onPressed: () {},
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
