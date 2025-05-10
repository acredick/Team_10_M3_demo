import 'package:DormDash/widgets/user_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_manager.dart';

class OrderManager {
  static final FirebaseFirestore _staticFirestore = FirebaseFirestore.instance;
  static final OrderManager _instance = OrderManager._internal();
  static String? _orderID;
  static String? delivererID;
  static String? customerID;

  factory OrderManager() {
    return _instance;
  }

  OrderManager._internal();

  static void setOrderID(String orderID) {
    print("order ID set to ${orderID}");
    _orderID = orderID;
  }

  static String? getOrderID() {
    if (_orderID != null) {
      return _orderID;
    } else {
      return "-1"; // no order
    }
  }

  // used for static testing
  static Future<void> updateAllOrderTimesToNow() async {
    try {
      final now = Timestamp.now(); // Firestore-compatible timestamp
      final ordersSnapshot = await _staticFirestore.collection('orders').get();

      for (var doc in ordersSnapshot.docs) {
        await _staticFirestore.collection('orders').doc(doc.id).update({
          'orderTime': now,
        });
        print("Updated orderTime for order: ${doc.id}");
      }

      print("All orderTimes updated successfully.");
    } catch (e) {
      print("Error updating orderTimes: $e");
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
  }

}
