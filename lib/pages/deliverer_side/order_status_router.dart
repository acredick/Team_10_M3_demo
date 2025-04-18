import '../../widgets/status_manager.dart';
import 'package:flutter/material.dart';
import '../../widgets/order_manager.dart';
import '/pages/deliverer_side/pickup_order.dart';
import '/widgets/bottom-nav-bar.dart';
import '/pages/deliverer_side/deliver_order.dart';

class OrderStatusRouter extends StatelessWidget {
  const OrderStatusRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final orderId = OrderManager.getOrderID();
    OrderManager.setOrderID(orderId!);
    print("orderID in status router: $orderId");

    if (orderId == "-1") {
      return Scaffold(
        body: Center(child: Text("Please select an order to deliver.")),
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: 1,
          onItemTapped: (index) {},
          userType: "deliverer",
        ),
      );
    }

    return FutureBuilder<int>(
      future: StatusManager.getOrderStatus(false, orderId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
            bottomNavigationBar: CustomBottomNavigationBar(
              selectedIndex: 1,
              onItemTapped: (index) {},
              userType: "deliverer",
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error: ${snapshot.error}")),
            bottomNavigationBar: CustomBottomNavigationBar(
              selectedIndex: 1,
              onItemTapped: (index) {},
              userType: "deliverer",
            ),
          );
        }

        final status = snapshot.data;
        print("status in status router: $orderId status $status vs database status${StatusManager.printStatus(false, orderId)}");

        if (status == 1) {
          return Scaffold(
            body: OrdersPage(orderId: orderId),
          );
        } else if (status == 2) {
          return Scaffold(
            body: DeliverOrder(orderId: orderId),
          );
        } else {
          return Scaffold(
            body: const Center(child: Text("Please select an order to deliver.")),
            bottomNavigationBar: CustomBottomNavigationBar(
              selectedIndex: 1,
              onItemTapped: (index) {},
              userType: "deliverer",
            ),
          );
        }
      },
    );
  }
}
