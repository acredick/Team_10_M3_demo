import 'package:DormDash/pages/shared/user_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/pages/shared/chat_manager.dart';

class OrderManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseFirestore _staticFirestore = FirebaseFirestore.instance;
  static final OrderManager _instance = OrderManager._internal();
  static String? _orderID;
  static String? delivererID;
  static String? customerID;
  static int? currentStatus;

  factory OrderManager() {
    return _instance;
  }

  OrderManager._internal();

  static void setOrderID(String orderID) {
    print("order ID set to ${orderID}");
    _orderID = orderID;
  }

  static String? getOrderID() {
    print("order ID = ${_orderID}");
    if (_orderID != null) {
      return _orderID;
    } else {
      return "-1"; // no order
    }
  }

  static Future<String?> getChatIDFromOrder(String orderID) async {
    try {
      DocumentSnapshot docSnapshot =
      await _staticFirestore.collection('orders').doc(orderID).get();

      if (docSnapshot.exists) {
        String? chatID = docSnapshot.get('chatID');
        print("chatID: $chatID");
        ChatManager.setChatID(chatID!);
        return chatID;
      } else {
        print("Order document does not exist.");
        return null;
      }
    } catch (e) {
      print("Failed to get chatID: $e");
      return null;
    }
  }

  static void setDelivererID() {
    // use email as ID
    delivererID = UserUtils.getEmail();
  }

  static void setCustomerID() {
    customerID = UserUtils.getEmail();
  }

  static Future<void> updateOrder(String orderID,
      String field,
      String value,) async {
    await _staticFirestore.collection('orders').doc(orderID).update({
      field: value,
    });
  }

  // used for local testing on one machine
  static void clearDelivererInfo(String orderID) {
    updateOrder(orderID, "delivererFirstName", "");
    updateOrder(orderID, "delivererID", "");
    updateOrder(orderID, "status", "Processing");
  }

  static Future<void> initializeStatus() async {
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
      print("Error advancing order status: $e");
    }
  }

  static Future<void> advanceStatus() async {
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

      int currentStatus = docSnapshot.get('status'); // Get current status

      int nextStatus = currentStatus + 1;

      if (nextStatus > 4) {
        print("Order is already at the final status.");
        return;
      }

      await _staticFirestore.collection('orders').doc(_orderID).update({
        "status": nextStatus,
      });

      currentStatus = nextStatus;
      print("Order status advanced to: $nextStatus");
    } catch (e) {
      print("Error advancing order status: $e");
    }
  }

  static Future<int> getStatus() async {
    try {
      DocumentSnapshot docSnapshot =
      await _staticFirestore.collection('orders').doc(_orderID).get();

      if (!docSnapshot.exists) {
        print("Order document not found.");
        return -1;
      }

      return docSnapshot.get('status'); // Get current status
    } catch (e) {
      print("unable to retrieve status: $e");
    }
    return -1;
  }

  static String printStatus() {
    switch (currentStatus) {
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
}
