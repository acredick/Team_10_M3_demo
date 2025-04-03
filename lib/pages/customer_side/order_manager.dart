import 'package:DormDash/pages/authentication/user_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderManager {
  static final OrderManager _instance = OrderManager._internal();
  static String? _orderID;
  static String? delivererID;
  static String? customerID;

  factory OrderManager() {
    return _instance;
  }

  OrderManager._internal();

  static void setOrderID(String orderID) {
    _orderID = orderID;
  }

  static String? getOrderID() {
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

}
