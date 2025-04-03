import 'package:DormDash/pages/shared/user_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
    print("order ID set to ${orderID}" );
    _orderID = orderID;
  }

  static String? getOrderID() {
    print("order ID = ${_orderID}" );
    if (_orderID != null) {
      return _orderID;
    } else {
      return "-1"; // no order
    }
  }

  static void setDelivererID() { // use email as ID
    delivererID = UserUtils.getEmail();
  }

  static void setCustomerID() {
    customerID = UserUtils.getEmail();
  }

  static Future<void> updateOrder(String orderID, String field, String value) async {
    await _staticFirestore.collection('orders').doc(orderID).update({
      field: value,
    });
  }

  static void clearDelivererInfo(String orderID) {
    updateOrder(orderID, "delivererFirstName", "");
    updateOrder(orderID, "delivererID", "");
    updateOrder(orderID, "status", "Processing");
  }

}
