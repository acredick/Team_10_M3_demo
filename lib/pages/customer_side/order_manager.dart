class OrderManager {
  static final OrderManager _instance = OrderManager._internal();
  static String? _orderID;

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
}
