class OrderManager {
  static final OrderManager _instance = OrderManager._internal();
  static String? _orderID;

  factory OrderManager() {
    return _instance;
  }

  OrderManager._internal();

  static void setOrderID(String orderID) {
    // _orderID = orderID;
    // todo: remove once firebase functionality is confirmed
    _orderID = "6e98badc-ee01-4bc5-aa32-294fd3a99dc0"; // sets order ID to an order already in database
  }

  static String? getOrderID() {
    if (_orderID != null) {
      return _orderID;
    } else {
      return "-1"; // no order
    }
  }
}
