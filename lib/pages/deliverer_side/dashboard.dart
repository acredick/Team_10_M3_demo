import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/pages/authentication/user_selection.dart';
import 'package:flutter/material.dart';
import 'package:DormDash/widgets/bottom-nav-bar.dart';
import 'package:DormDash/pages/deliverer_side/pickup_order.dart';
import '/pages/authentication/user_util.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, this.user});
  final User? user;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isOrderAccepted = false; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width * 0.98,
              height: 200,
              decoration: BoxDecoration(
                color: Color(0xFF5B3184),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          padding: EdgeInsets.only(right: 10),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              UserUtils.getFullName(),
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        Text("Earned Money", style: TextStyle(color: Colors.white70, fontSize: 12)),
                        Text("\$000.000", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 30),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.3,
                        width: MediaQuery.of(context).size.width * 0.4,
                        color: Colors.white,
                        child: Image.asset('assets/images/mapimage.png', fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Orders Available", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),

            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .where('status', isEqualTo: 'Processing') // Get only processing orders
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator()); // Loading indicator
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No orders available"));
                  }

                  return ListView(
                    children: snapshot.data!.docs.map<Widget>((doc) {
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(15),
                          title: Text(
                            doc['restaurantName'],
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Pickup: ${doc['restaurantAddress']}\nDropoff: ${doc['customerAddress']}\nPrice: \$${doc['price']}",
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              String orderId = doc.id;  // Get the orderId
                              
                              // Navigate to OrdersPage and pass the orderId
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrdersPage(orderId: orderId), // Pass orderId
                                ),
                              );

                              // Update Firestore when the order is accepted
                              FirebaseFirestore.instance.collection('orders').doc(orderId).update({
                                'status': 'Accepted'
                              });
                            },
                            child: Text("Accept"),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
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
