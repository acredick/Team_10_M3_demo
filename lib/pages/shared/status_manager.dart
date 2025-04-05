import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/pages/shared/order_manager.dart';


class StatusManager {
  static final FirebaseFirestore _staticFirestore = FirebaseFirestore.instance;

  static final StatusManager _instance = StatusManager._internal();
  static int? currentStatus;
  factory StatusManager() => _instance;
  StatusManager._internal();

  static Future<int> getOrderStatus(bool isChatID, String id) async {
    String orderID = "";

    if (isChatID) {
      try {
        DocumentSnapshot chatDocSnapshot = await _staticFirestore.collection('chats').doc(id).get();

        if (!chatDocSnapshot.exists) {
          print("Chat document not found.");
          return -1;
        }

        orderID = chatDocSnapshot.get('orderID');
      } catch (e) {
        print("Error retrieving status from chatID: $e");
        return -1;
      }
    } else {
      orderID = id;
    }

    try {
      DocumentSnapshot docSnapshot = await _staticFirestore.collection('orders').doc(orderID).get();
      if (!docSnapshot.exists) {
        print("Order document not found.");
        return -1;
      }

      int status = docSnapshot.get('status');

      return status;
    } catch (e) {
      print("Error retrieving order status: $e");
      return -1;
    }
  }

  static Future<String> printStatus(bool isChatID, String id) async {
    int status = await getOrderStatus(isChatID, id);

    switch (status) {
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

  static Future<void> initializeStatus() async {
    String? _orderID = OrderManager.getOrderID();
    if (_orderID == null) {
      print("Order ID is null. Cannot initialize status.");
      return;
    }

    try {
      DocumentSnapshot docSnapshot =
      await _staticFirestore.collection('orders').doc(_orderID).get();

      if (!docSnapshot.exists) {
        print("Order document not found.");
        return;
      }

      await _staticFirestore.collection('orders').doc(_orderID).update({
        "status": 0,
      });

      currentStatus = 0;
      print("Order status initialized.");
    } catch (e) {
      print("Error initializing order status: $e");
    }
  }

  static Future<void> advanceStatus() async {
    String? _orderID = OrderManager.getOrderID();

    if (_orderID == null) {
      print("Order ID is null. Cannot advance status.");
      return;
    }

    try {
      DocumentSnapshot docSnapshot =
      await _staticFirestore.collection('orders').doc(_orderID).get();

      if (!docSnapshot.exists) {
        print("Order document not found.");
        return;
      }

      int currentStatus = docSnapshot.get('status');
      int nextStatus = currentStatus + 1;

      await _staticFirestore.collection('orders').doc(_orderID).update({
        "status": nextStatus,
      });

      StatusManager.currentStatus = nextStatus;
      print("Order status advanced to: $nextStatus");

      if (nextStatus == 3) {
        watchForDeliveryCompletion(_orderID);
      }
    } catch (e) {
      print("Error advancing order status: $e");
    }
  }

  static void watchForDeliveryCompletion(String orderID) async {
    try {
      DocumentSnapshot docSnapshot =
      await _staticFirestore.collection('orders').doc(orderID).get();

      int currentStatus = docSnapshot.get('status');
      if (currentStatus == 3) {
        print("Status is 'Delivered'. Starting 1-minute timer...");

        Timer(const Duration(minutes: 1), () async {
          DocumentSnapshot updatedSnapshot =
          await _staticFirestore.collection('orders').doc(orderID).get();

          int latestStatus = updatedSnapshot.get('status');
          if (latestStatus == 3) {
            await _staticFirestore.collection('orders').doc(orderID).update({
              'status': 4,
            });
            print("Status automatically updated to 'Complete'.");
          } else {
            print("Status changed manually before timer completed.");
          }
        });
      }
    } catch (e) {
      print("Error in delivery completion timer: $e");
    }
  }
}
