import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:DormDash/widgets/bottom-nav-bar.dart';
import 'package:DormDash/pages/deliverer_side/pickup_order.dart';
import '../../widgets/user_util.dart';
import '../../widgets/order_manager.dart';
import '../../widgets/chat_manager.dart';
import '../../widgets/status_manager.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, this.user});
  final User? user;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isOrderAccepted = false; 
  double totalEarnings = 0.0;

Future<void> fetchTotalEarnings() async {
  final email = UserUtils.getEmail();

  final snapshot = await FirebaseFirestore.instance
      .collection('orders')
      .where('delivererID', isEqualTo: email)
      .where('status', isEqualTo: 3) 
      .get();

  double total = 0.0;
  for (var doc in snapshot.docs) {
    total += (doc['price'] as num).toDouble();
  }


  setState(() {
    totalEarnings = total;
  });
}

  setState(() {
    totalEarnings = total;
  });
}

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
       child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10, left: 7, right: 7),
              height: 200,
              decoration: BoxDecoration(
                color: Color(0xFF5B3184),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          Flexible(
                            child: Text(
                              UserUtils.getFullName(),
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Earned Money",
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Text(
                            "\$${totalEarnings.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: MediaQuery.of(context).size.width * 0.35,
                          width: MediaQuery.of(context).size.width * 0.4,
                          color: Colors.white,
                          child: Image.asset(
                            'assets/images/mapimage.png',
                            fit: BoxFit.cover,
                          ),
                        ),
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
                child: Text(
                  "Orders Available",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .where('status', isEqualTo: 0)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
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
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Pickup: ${doc['restaurantAddress']}\nDropoff: ${doc['address']}\nPrice: \$${doc['price']}",
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () async {
                              String orderId = doc.id;

                              OrderManager.updateOrder(orderId, "delivererID", UserUtils.getEmail());
                              OrderManager.updateOrder(orderId, "delivererFirstName", UserUtils.getFirstName());
                              OrderManager.setOrderID(orderId);
                              print("Dasher accepted order. Advancing status...");
                              StatusManager.advanceStatus();

                              String? chatid = await OrderManager.getChatIDFromOrder(orderId);
                              if (chatid != null) {
                                ChatManager.setDelivererInfo();
                              } else {
                                print("Failed to retrieve chatID, skipping setDelivererInfo()");
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrdersPage(orderId: orderId),
                                ),
                              );
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
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 0,
        userType: "deliverer",
        onItemTapped: (index) {},
      ),
      
    );
  }
}

